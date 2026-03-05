import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const FCalcApp());
}

class FCalcApp extends StatelessWidget {
  const FCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _display = '0';
  String _equation = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _display = '0';
        _equation = '';
        _firstOperand = null;
        _operator = null;
      } else if (text == '±') {
        if (_display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else if (text == '%') {
        double val = double.parse(_display) / 100;
        _display = val.toString();
      } else if (['+', '-', '×', '÷'].contains(text)) {
        _firstOperand = double.parse(_display);
        _operator = text;
        _equation = '$_display $text';
        _shouldResetDisplay = true;
      } else if (text == '=') {
        if (_firstOperand != null && _operator != null) {
          double secondOperand = double.parse(_display);
          double result = 0;
          switch (_operator) {
            case '+': result = _firstOperand! + secondOperand; break;
            case '-': result = _firstOperand! - secondOperand; break;
            case '×': result = _firstOperand! * secondOperand; break;
            case '÷': result = _firstOperand! / secondOperand; break;
          }
          _equation = '$_equation $secondOperand =';
          _display = result.toString().endsWith('.0') 
              ? result.toInt().toString() 
              : result.toString();
          _firstOperand = null;
          _operator = null;
          _shouldResetDisplay = true;
        }
      } else {
        // Brojevi i tačka
        if (_shouldResetDisplay) {
          _display = text;
          _shouldResetDisplay = false;
        } else {
          _display = _display == '0' ? text : _display + text;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? bgColor, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => _onButtonPressed(text),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: bgColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Ekran za prikaz
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _equation,
                      style: TextStyle(
                        fontSize: 24,
                        color: colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tastatura
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('C', bgColor: colorScheme.errorContainer, textColor: colorScheme.onErrorContainer),
                      _buildButton('±', bgColor: colorScheme.secondaryContainer),
                      _buildButton('%', bgColor: colorScheme.secondaryContainer),
                      _buildButton('÷', bgColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('×', bgColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-', bgColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+', bgColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton('=', bgColor: colorScheme.tertiary, textColor: colorScheme.onTertiary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
