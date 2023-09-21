//* Login Exceptions
class InvalidLoginCredentialsException implements Exception {}

class InvalidEmailException implements Exception {}

//* Register Exceptions

class WeakPasswordException implements Exception {}

class EmailAlreadyinUseException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//* Generic Exceptions

class GenericAuthExceptions implements Exception {}

class UserNotLoggedInException implements Exception {}
