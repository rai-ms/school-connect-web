part of '../validation.dart';

abstract class ValidationStrings {
  static const String improperEmail = "Please enter valid email";
  static const String invalidLengthPassword = 'Please enter at least 8+ characters';
  static const String improperPassword = 'Please enter a valid password having minimum of 8 characters, an uppercase letter, a lowercase letter, a number, and a special character.';
  static const String improperPhone = "Please enter a valid phone number.";
  static const String reachedAtMaxLength = 'Phone Number must be less than or equal to 13 digits.';
  static const String notReachedAtMinLength = 'Phone Number must be greater than or equal to 5 digits.';
  static const String invalidLengthPhone = 'Phone Number must be of 10 digits';
  static const String incorrectRepeatPassword = "New Password and Confirm Password doesn't match";
  static const String improperName = 'Please enter 1-50 characters.';
  static const String tooLongName = 'Oops! The name entered is too long. Please limit the name to maximum 56 characters.';
  static const String tooShortName = "Sorry, the name provided is too short. Please enter a name with at least minimum of 3 characters.";

  /// Below can be used as per the requirements
  static const String emptyField = 'Field cannot be Empty';
  static const String emptySearchField = "Please enter a search term to find what you're looking for.";
  static const String improperDecimal = 'Please Enter a Proper Number';
  static const String improperSpaceName = 'Name Cannot contain Empty Spaces';
  static const String improperDate = 'Please Enter a Proper in the format dd/mm/yyyy';
  static const String invalidLengthPercentage = 'Percentage must be less than or Equal to 100';
  static const String improperPercentage = 'Please Enter a proper Number';
  static const String improperFirstPhone = 'Phone Number must not start with 0';
  static const String improperCountryCodeFirst = "Country Code must start with '+'";
  static const String improperCountryCode = 'Please enter a proper country code';
  static const String improperSingleNumber = 'Please Enter a Proper Number';
  static const String invalidLengthSingleNumber = 'Value must be of only 1 digit';
  static const String invalidSearchLengthString = 'Please enter at least 2 characters to perform a search';
  static const String invalidDescriptionLength = 'Field cannot be more than 500 Letters';
  static const String invalidSubjectLength = 'Subject cannot be less than 3 Letters';
  static const String invalidUserName = "Invalid Username";
  static const String invalidReferralCode = "Invalid referral code";
}
