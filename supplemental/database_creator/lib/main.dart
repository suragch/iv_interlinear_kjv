import 'create_ot_database.dart';
import 'html_to_csv.dart';
import 'simplify_hebrew_csv.dart';

Future<void> main() async {
  // await convertOtHtmlToCsv();
  // createHebrewInterlinear();
  await createOtDatabase();
}
