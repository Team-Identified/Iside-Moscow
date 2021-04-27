import 'package:url_launcher/url_launcher.dart';

void tryLaunch(String url) async{
  // bool ability = await canLaunch(url);
  // if (ability){
  //   await launch(url);
  // }
  await launch(url);
}
