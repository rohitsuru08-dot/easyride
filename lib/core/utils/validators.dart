// Input validation utility functions
class Validators {
  // Validate phone number (10 digits)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove any spaces or special characters
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.length != 10) {
      return 'Phone number must be 10 digits';
    }
    
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber)) {
      return 'Invalid phone number';
    }
    
    return null;
  }
  
  // Validate OTP (6 digits)
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }
  
  // Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name must contain only letters';
    }
    
    return null;
  }
  
  // Validate location selection
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a location';
    }
    return null;
  }
  
  // Validate date selection
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    if (selectedDate.isBefore(todayDate)) {
      return 'Please select a future date';
    }
    
    return null;
  }
}
