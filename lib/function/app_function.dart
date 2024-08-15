String abbreviateNumber(num number) {
  if (number.abs() < 1000) return number.toInt().toString();

  final units = ['', 'k', 'M', 'B', 'T'];
  int unitIndex = 0;
  double abbreviatedNumber = number.toDouble();

  while (abbreviatedNumber.abs() >= 1000 && unitIndex < units.length - 1) {
    abbreviatedNumber /= 1000;
    unitIndex++;
  }

  return '${abbreviatedNumber.toStringAsFixed(1)} ${units[unitIndex]}';
}
