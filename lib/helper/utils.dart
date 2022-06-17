class Utils {

  static bool isOverlapped(int s1, int e1, int s2, int e2) {
    if((s2 > s1 && s2 < e1) || (e2 > s1 && e2 < e1)) {
      return true;
    } else {
      return false;
    }
  }
}