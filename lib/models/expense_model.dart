class ExpenseModel {
  // The most important field: the suggested total amount
  final double totalAmount;
  // We keep the raw text handy in case parsing fails or for debugging
  final String rawText;

  ExpenseModel({
    required this.totalAmount,
    required this.rawText,
  });

  // Helper to format currency nicely
  String get formattedAmount => totalAmount.toStringAsFixed(2);
}