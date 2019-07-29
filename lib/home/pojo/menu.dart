class QuickMenu implements IQuickMenu{
  /// 菜单名称
  String name;
  /// id
  String id;
  /// 网络蹄片地址
  String image;
  /// 页面类型
  int windowType;


  QuickMenu(this.name, this.image);

  @override
  String getId() {
    return id;
  }

  @override
  String getName() {
    return name;
  }

  @override
  String getImage() {
    return image;
  }

  @override
  int getWindowType() {
    return windowType;
  }

}
abstract class IQuickMenu{
  String getName();
  String getId();
  String getImage();
  int getWindowType();
}