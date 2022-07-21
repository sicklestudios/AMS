import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

String getDate()
{
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day+2}-${dateParse.month}-${dateParse.year}";
  return formattedDate;
}
addData(context) async {
  UserProvider _userVal = Provider.of<UserProvider>(context, listen: false);
  await _userVal.refreshUser();
}