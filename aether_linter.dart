import 'dart:io';

/// Aether Architecture Linter (Diagnostic Mode)
/// This tool runs diagnostics to ensure code quality and concurrency safety.
void main() async {
  print('===================================================');
  print('🛡️  Aether Architecture Linter (Diagnostic Mode) 🛡️');
  print('===================================================');

  final File pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('❌ CRITICAL ERROR: Not running in a Flutter project root.');
    print('💡 HEALING: `cd` into your project directory before running this.');
    return;
  }

  final File reportFile = File('ARCHITECTURE_REPORT.md');
  final StringBuffer out = StringBuffer();
  out.writeln('# Aether Diagnostic Report\n');

  // 1. Strict Lints
  print('⏳ Running Diagnostic: Code Quality (flutter analyze)...');
  try {
    final ProcessResult analyze = await Process.run('flutter', ['analyze']);
    if (analyze.exitCode == 0) {
      print('✅ Linter: PASS');
      out.writeln('### 1. Code Quality');
      out.writeln('✅ **PASS:** Zero static analysis warnings.');
    } else {
      print('❌ Linter: FAIL');
      out.writeln('### 1. Code Quality');
      out.writeln('❌ **FAIL:** Static analysis found issues.');
      out.writeln('\n💡 **HEALING ACTION:** Look at the terminal output of `flutter analyze` and resolve the warnings.');
    }
  } catch (e) {
    print('❌ CRITICAL ERROR: Could not run "flutter analyze".');
    return;
  }

  // 2. Concurrency Verification
  print('⏳ Running Diagnostic: Concurrency Check (flutter test)...');
  final File testFile = File('test/raid_concurrency_test.dart');
  
  if (!testFile.existsSync()) {
    print('❌ Tests: FAIL (raid_concurrency_test.dart is missing)');
    out.writeln('\n### 2. Concurrency Outcome');
    out.writeln('❌ **FAIL:** Missing test file.');
  } else {
    try {
      final ProcessResult testResult = await Process.run('flutter', ['test', 'test/raid_concurrency_test.dart']);
      if (testResult.exitCode == 0) {
        print('✅ Tests: PASS');
        out.writeln('\n### 2. Concurrency Outcome');
        out.writeln('✅ **PASS:** Your architecture survived the Thundering Herd.');
      } else {
        print('❌ Tests: FAIL');
        out.writeln('\n### 2. Concurrency Outcome');
        out.writeln('❌ **FAIL:** Concurrency test failed.');
      }
    } catch (e) {
      print('❌ CRITICAL ERROR: Could not execute "flutter test".');
    }
  }

  try {
    reportFile.writeAsStringSync(out.toString());
    print('\n===================================================');
    print('📄 Report saved to ARCHITECTURE_REPORT.md');
    print('===================================================');
  } catch (e) {
    print('❌ Could not write to ARCHITECTURE_REPORT.md.');
  }
}
