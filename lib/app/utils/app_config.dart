
class AppConfig {

  static const String baseUrl = "https://turningindia.com/Delivery";
  static final String mapApiKey= 'AIzaSyBu_hPjmC3jAI9s0wVqyRc03AWS4p0OLxc';
  static const String imageUrl = "https://turningindia.com/Delivery/uploads/";

  static const String loginUrl = "/delivery/auth/login";
  static const String registerUrl = "/delivery/auth/register";
  static const String verifyOtpUrl = "/delivery/auth/verify_otp";
  static const String forgotPasswordUrl = "/delivery/auth/forget_password";
  static const String forgotPasswordOtpUrl = "/delivery/auth/verify_forget_otp";
  static const String resetPasswordUrl = "/delivery/auth/reset_password";
  static  String getContent(String? type) => "/delivery/content/fetchaboutcontent?content_type=$type";
  static const String helpAndSupport = "/delivery/help/fetch_help_support";
  static const String updateProfileUrl = "/delivery/auth/edit_profile";
  static const String getHomeCategory = "/delivery/home/homepage";
  static const String getSubCategoryByCategory = "/delivery/category/sub/get_sub_category_by_category/";
  static const String getTabProductByCategory = "/delivery/product/get_product_by_category/";
  static const String getSimilarProduct = "/delivery/product/similar/";
  static const String likeUnlikeFavorite = "/delivery/favorite/like_unlike";
  static const String favouriteList = "/delivery/favorite/list";
  static const String addToCart = "/delivery/cart/add_to_cart";
  static const String getCartItems = "/delivery/cart/get_cart";

  static const String getMyOrdersUrl = "/delivery/order/get_my_orders";
  static const String createOrderUrl = "/delivery/order/create";
  static const String getMyAddressUrl = "/delivery/users/address/list";
  static const String addAddressUrl = "/delivery/users/address/add";
  static const String deleteAddressUrl = "/delivery/users/address/delete/";
  static const String setDefaultAddressUrl = "/delivery/users/address/set-default/";
  static const String searchProductUrl = "/delivery/product/get_product?search=";


}