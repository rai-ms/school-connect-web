extension APIStatusErrorMessage on int? {
  String get message {
    switch (this) {
      case 200:
        return "Success";
      case 201:
        return "Resource Created";
      case 202:
        return "Request Accepted";
      case 204:
        return "No Content";

      case 301:
      case 302:
        return "Resource Moved";

      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Forbidden";
      case 404:
        return "Not Found";
      case 405:
        return "Method Not Allowed";
      case 408:
        return "Request Timeout";
      case 409:
        return "Conflict";
      case 422:
        return "Unprocessable Entity";
      case 429:
        return "Too Many Requests";

      case 500:
        return "Internal Server Error";
      case 502:
        return "Bad Gateway";
      case 503:
        return "Service Unavailable";
      case 504:
        return "Gateway Timeout";

      case null:
        return "No Status Code";
      default:
        return "Unknown Error";
    }
  }
}
