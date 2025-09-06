// change-class: infra
// ReleaseGatesIntegration: Generates a final mapping table of release gates.
// Outputs:
//  - docs/RELEASE_GATES.md (human-readable mapping table and summary)
//  - docs/metrics/release_gates.json (machine-readable for dashboards)
//  - README marker <!-- AUTO:README_RELEASE_GATES --> summary

import 'dart:convert';
import 'dart:io';

class Gate {
  final String id;
  final String name;
  final String script; // primary script path, if any
  final List<String> workflows; // workflow filenames involved
  final bool mandatory; // intended to be blocking in CI
  String status = 'unknown'; // ok | warn | missing | planned | unknown
  String notes = '';
  Gate({
    required this.id,
    required this.name,
    required this.script,
    required this.workflows,
    required this.mandatory,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'script': script,
        'workflows': workflows,
        'mandatory': mandatory,
        'status': status,
        'notes': notes,
      };
}

void main(List<String> args) {
  final gates = <Gate>[
    Gate(
      id: 'stub_parity',
      name: 'Stub Parity',
      script: 'tools/check_stub_parity.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'manifest',
      name: 'Manifest Completeness',
      script: 'tools/check_manifest.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'coverage_threshold',
      name: 'Coverage Threshold',
      script: 'tools/coverage_policy.yaml',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'route_spec_hash',
      name: 'Route Spec Hash (strict)',
      script: 'tools/check_spec_hashes.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'analytics_tests_count',
      name: 'Analytics Tests Minimum',
      script: 'tools/run_quality_gates.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'package_status_audit',
      name: 'Package Status Audit',
      script: 'tools/package_status_audit.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: false,
    ),
    Gate(
      id: 'schema_validator',
      name: 'Content Pack Schemas',
      script: 'tools/schema_validator/bin/validate_schemas.dart',
      workflows: ['.github/workflows/ci.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'policy_gitleaks',
      name: 'Policy Guard (Gitleaks)',
      script: '.github/workflows/gitleaks.yml',
      workflows: ['.github/workflows/gitleaks.yml'],
      mandatory: true,
    ),
    Gate(
      id: 'checklist_visibility',
      name: 'Checklist Visibility',
      script: 'tools/generate_task_checklist.dart',
      workflows: ['.github/workflows/checklist-visibility.yml'],
      mandatory: false,
    ),
    Gate(
      id: 'stack_consolidation',
      name: 'Stack Consolidation',
      script: 'tools/consolidate_stack_docs.dart',
      workflows: ['.github/workflows/consolidate-stack.yml'],
      mandatory: false,
    ),
    Gate(
      id: 'golden_guard',
      name: 'Golden Guard (planned)',
      script: '.github/workflows/golden-guard.yml',
      workflows: ['.github/workflows/golden-guard.yml'],
      mandatory: true,
    ),
  ];

  // Evaluate presence and status heuristics
  final workflowsDir = Directory('.github/workflows');
  final hasWorkflows = workflowsDir.existsSync()
      ? workflowsDir.listSync().whereType<File>().map((f) => f.path).toSet()
      : <String>{};

  // Parse METRICS for a couple of signals
  final metrics = File('docs/METRICS.md').existsSync()
      ? File('docs/METRICS.md').readAsStringSync()
      : '';
  final stubOk = RegExp(r'Stub parity:\s*OK', caseSensitive: false)
      .hasMatch(metrics);
  final coverageMatch = RegExp(r'Coverage:\s*([0-9]+\.[0-9]+)%')
      .firstMatch(metrics);
  final coveragePct = coverageMatch != null ? coverageMatch.group(1) : null;

  for (final g in gates) {
    // script presence
    final exists = File(g.script).existsSync() || Directory(g.script).existsSync();
    // workflows presence
    final wfPresent = g.workflows.where((w) => hasWorkflows.contains(w)).toList();
    // status heuristics
    if (!exists) {
      g.status = g.id == 'golden_guard' ? 'planned' : 'missing';
      g.notes = exists ? '' : 'source not found';
    } else {
      g.status = 'configured';
    }
    if (g.id == 'stub_parity' && stubOk) {
      g.status = 'ok';
      g.notes = 'parity OK per docs/METRICS.md';
    }
    if (g.id == 'coverage_threshold' && coveragePct != null) {
      g.notes = 'coverage $coveragePct%';
    }
    if (wfPresent.isEmpty) {
      g.notes = (g.notes.isEmpty ? '' : g.notes + '; ') + 'no workflow found';
    }
    // Attach list of found workflows to notes if not all are missing
    if (wfPresent.isNotEmpty) {
      g.notes = (g.notes.isEmpty ? '' : g.notes + '; ') + 'workflow: ' + wfPresent.join(', ');
    }
  }

  // Summaries
  final total = gates.length;
  final configured = gates.where((g) => g.status == 'configured' || g.status == 'ok').length;
  final planned = gates.where((g) => g.status == 'planned').length;
  final missing = gates.where((g) => g.status == 'missing').length;
  final mandatoryConfigured = gates.where((g) => g.mandatory && (g.status == 'configured' || g.status == 'ok')).length;
  final mandatoryTotal = gates.where((g) => g.mandatory).length;

  // Write JSON
  final metricsDir = Directory('docs/metrics')..createSync(recursive: true);
  File('${metricsDir.path}/release_gates.json').writeAsStringSync(jsonEncode({
    'generated': DateTime.now().toUtc().toIso8601String(),
    'summary': {
      'total': total,
      'configured': configured,
      'planned': planned,
      'missing': missing,
      'mandatoryConfigured': mandatoryConfigured,
      'mandatoryTotal': mandatoryTotal,
    },
    'gates': gates.map((g) => g.toJson()).toList(),
  }));

  // Write Markdown
  final md = StringBuffer()
    ..writeln('# Release Gates — Final Mapping')
    ..writeln()
    ..writeln('Generated: ${DateTime.now().toUtc().toIso8601String()}')
    ..writeln()
    ..writeln('Summary: configured $configured/$total (mandatory: $mandatoryConfigured/$mandatoryTotal), planned $planned, missing $missing')
    ..writeln()
    ..writeln('| Gate | Script | Workflow | Mandatory | Status | Notes |')
    ..writeln('|------|--------|----------|-----------|--------|-------|');
  for (final g in gates) {
    final wf = g.workflows.isEmpty ? '' : g.workflows.join('<br>');
    md.writeln('| ${g.name} | `${g.script}` | ${wf} | ${g.mandatory ? 'Yes' : 'No'} | ${g.status} | ${g.notes} |');
  }
  final outFile = File('docs/RELEASE_GATES.md');
  outFile.createSync(recursive: true);
  outFile.writeAsStringSync(md.toString());

  // Update README marker
  final readme = File('README.md');
  if (readme.existsSync()) {
    final stamp = 'Gates: $configured/$total (mandatory: $mandatoryConfigured/$mandatoryTotal)';
    final txt = _replaceMarker(readme.readAsStringSync(), 'AUTO:README_RELEASE_GATES', stamp);
    readme.writeAsStringSync(txt);
  }

  stdout.writeln('Generated release gates mapping: configured=$configured total=$total');
}

String _replaceMarker(String text, String marker, String value) {
  final pattern = RegExp('<!-- $marker -->(.*?)<!-- END -->', dotAll: true);
  if (pattern.hasMatch(text)) {
    return text.replaceAllMapped(
        pattern, (m) => '<!-- $marker -->$value<!-- END -->');
  }
  return text.trimRight() + '\n\n<!-- $marker -->' + value + '<!-- END -->\n';
}
