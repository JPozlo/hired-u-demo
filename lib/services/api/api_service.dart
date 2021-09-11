class ApiService {
  /// URLs
  static const String appBaseURL =
      "https://uhired.herokuapp.com/api/v1.0.1/user/";
  static const String resetBaseURL = "http://uhired.herokuapp.com/";
  // User
  static const String createNewUser = appBaseURL + "register";
  static const String loginUser = appBaseURL + "login";
  static const String resetPassword = resetBaseURL + "password/reset";
  static const String logoutUser = appBaseURL + "logout";
  static const String fetchUser = appBaseURL + "get";
  static const String fetchIP = appBaseURL + "getip";
  // Order
  static const String baseOrdersURL = appBaseURL + "orders/";
  static const String fetchAllOrders = baseOrdersURL + "";
  static const String viewOrder = baseOrdersURL + "view";
  static const String payOrder = baseOrdersURL + "pay";
  static const String createOrder = appBaseURL + "create/order";

  // Products
  static const String fetchProducts = appBaseURL + "products";

  // Services
  static const String fetchServices = appBaseURL + "services";
}
