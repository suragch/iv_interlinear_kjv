import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() {
    return HelpScreenState();
  }
}

class HelpScreenState extends State<HelpScreen> {
  //WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    //_loadHtmlFromAssets();
    return Scaffold(
      appBar: AppBar(title: Text('IV Interlinear KJV')),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
        child: WebView(
          initialUrl: Uri.dataFromString(htmlString,
                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString(),
          //onWebViewCreated: (WebViewController webViewController) {
          //  _controller = webViewController;
          //},
        ),
      ),
    );
  }

// FIXME error loading from Android
//  _loadHtmlFromAssets() async {
//    String fileText = await rootBundle.loadString('assets/intro.html');
//    print('found file: $fileText');
//    _controller.loadUrl( Uri.dataFromString(
//        fileText,
//        mimeType: 'text/html',
//        encoding: Encoding.getByName('utf-8')
//    ).toString());
//  }
}

// I was getting errors in Android trying to load the following text
// from the assets file, so I am just putting it here.
final String htmlString = '''
<html><body >
<h3 style="text-align: center;">Comparison of Inspired Version</h3>
<h3 style="text-align: center;">with the King James Version</h3>
<h3 style="text-align: center;">and with a Greek Interlinear Bible</h3>
<h3 style="text-align: center;">Complied by Jack Sande</h3>
<p>The Holy Bible, Berean Interlinear Bible<br /> Copyright &copy;2016 by Bible Hub<br /> Used by Permission. All Rights Reserved Worldwide.</p>
<p><strong>What is the purpose of this parallel versions?</strong></p>
<p>The parallel version allows the reader to quickly distinguish the differences and the similarities between the King James Version and Joseph Smith&rsquo;s Inspired Version. In addition an accompanying Greek New Testament text is added for reference and further study.</p>
<p><strong>What are the benefits for this parallel reference?</strong></p>
<p>This scholarly work is to benefit the reader in four ways.</p>
<p>The majority of reference books are geared to the King James Version of the Bible. Concordances, Bible dictionaries, commentaries all use numbering systems (chapter and verse) which is also the same used by the King James Version. Joseph Smith&rsquo;s Inspired Version has his own numbering system making it very difficult to use many of the references available. With this parallel study, a verse directed to the numbering system of the King James Version could quickly be cross referenced in the Inspired Version and read in the context of other verses.</p>
<p>It is a tedious task to compare the differences between the Inspired Version and the King James Version. This references highlights the change in words using bold and underlining to show words that appear in one version but does not appear in the other version.</p>
<p>The Berean Interlinear Bible¹ is an additional tool to allow the non-Greek reader to check out the meaning of Greek words used for various Bible translations today. Each Greek word is followed by an English translation. The English is hyperlinked to a more detailed explanation of the Greek word. For those not knowing Greek one could also copy the Greek word and have the Internet interpret the word.</p>
<p>This reference has the advantage of being able to read any of the versions (IV, KJV, and Greek) in the order available in any hard copy. Previously there was one excellent reference book (Joseph Smith&rsquo;s &ldquo;New Translation&rdquo; of the Bible²) showing only the verses with differences between the King James Version and the Inspired Version. The verses that did not have differences were not printed, making reading a continuing narrative difficult. Also sometimes the passages of Joseph Smith&rsquo;s work were reorganized from what is found in the King James Version. The text of a chapter might have verses 5 and 8 switched with the order found in the other version.</p>
<p><strong>Why include Greek?</strong></p>
<p>The New Testament was written in Greek and multiple hand written copies were made of them as Christianity spread throughout the Roman world. Translations like the King James Version has relied on the Greek text for its English translation. Since the King James Version has been translated, there have been 1,000s of Greek manuscripts available to scholars. This Greek text included in this parallel version is based on more of the latest Greek manuscripts.</p>
<p><strong>Were there errors in the Greek text?</strong></p>
<p>There are errors in the Greek manuscripts. Errors can be accidental or intentional. It is difficult to rewrite a text of any length without making some errors. These variations and errors in the text will be further copied when the copy of the copy is rewritten. There is the variants of the parent copy plus additional variants of its own³ creating spelling errors and points of grammar issues. Similar looking Greek letters could be interchanged.⁴ A damaged or poorly written manuscript can create copyist errors. The earliest manuscripts were written without spaces between words which can create some unique translations. For instance &ldquo;NOWHERE&rdquo;, does it mean &ldquo;now here&rdquo; or &ldquo;no where&rdquo;?⁵ Intentional errors could include trying to correct a perceived grammar or spelling error, trying to harmonize with another passage, making a theological change, or trying to clear up a difficulty.⁶</p>
<p><strong>How are errors detected and corrected in the Greek text?</strong></p>
<p>Most of the discovered Greek manuscripts were not available for study during Joseph Smith&rsquo;s day. Since then there have been a number of significant Greek New Testament manuscript finds. The Chester Beatty papyri were purchased and announced to the world in 1931 with a few additional manuscripts added to the other papyri in the following decade.⁷ These New Testament manuscripts included much of the Gospels, Acts, Pauline epistles, and Revelation.⁸ The John Rylands Papyrus contains a tiny portion of the Gospel of John. It was purchased in Egypt in 1920. This copy has been dated in the first half of the second century⁹ or within 100 years of the original.¹⁰ In 1952 there were papyri found in Egypt. Purchased by Martin Bodmer, the oldest papyrus dates to 200 AD. The Bodmer Papyri included portions of John, Jude, epistles of Peter, and Luke.¹¹ In 1852 Constantin von Tischendorf discovered an entire Greek New Testament manuscript in a monastery on Mount Sinai. The manuscript became known as Codex Sinaiticus. He convinced the monks to present it as a gift to the czar of Russia whose influence could be seen as the proctor of the Greek Church.¹² That Codex was written about 1600 years ago.¹³ Although the Vatican Library at Rome has had Codex Vaticanus since before 1475, this fourth century Greek New Testament was not made available to the world until 1890 when a photographic facsimile was made.¹⁴ Today there are over 5,800 Greek Manuscripts available.¹⁵ Scholars have used these manuscripts to piece together the Greek New Testament.</p>
<p><strong>Were there any other sources for the Greek Bible other than Biblical Greek manuscripts?</strong></p>
<p>Because Christianity was a missionary organization from the beginning the books of the New Testament were being translated into other languages. Some of the languages include Latin, Syriac, Peshitta, Coptic, Gothic, Armenian, Ethiopic, Georgian, Slavonic, and Arabic.¹⁶ Bibles in other languages could be compared to the text of the Greek New Testament to affirm or disaffirm what was in the Greek text.</p>
<p>Another source of cross checking the reliability of the Greek text are the writings by the early Christians. These Christians quoted portions of the New Testament in their commentaries, sermons, and other treatises. These writings help to date the Greek manuscripts they quote from.¹⁷ And comparisons can then be made for checking the accuracy of the Greek text.¹⁸</p>
<p><strong>How serious are the errors in the Greek texts?</strong></p>
<p>Using the various resources of Greek manuscripts, various early translations, and early patristic writings most errors have been corrected. There are about 20,000 lines in the New Testament. Only 40 lines are in question. That is less than 1% of the New Testament.¹⁹ The main passages that are in doubt of those 40 lines are Mark 16:9-20, John 7:53-8:11, and 1 John 5:7. With the significant variant readings being less than one-half of one percent corrupted, none of the variant readings in doubt has any effect on doctrine.²⁰ Richard Lloyd Anderson, Associate Professor of History and Scripture at Brigham Young University stated, "[A]ll manuscripts agree on the essential correctness of 99% of the verses in the New Testament.&rdquo;²¹</p>
<p><strong>Was the King James Version based on a reliable Greek text?</strong></p>
<p>Erasmus created an edition of the Greek New Testament which was based on only six manuscripts. The best of those manuscripts Erasmus did not rely on much. Later Erasmus consulted a few additional manuscripts and made only minor changes. He included I John 5:7-8 which had no Greek support. Erasmus&rsquo; Greek edition became the basis for other Greek editions, eventually evolving into the Textus Receptus (T.R.). J. Harold Greenlee had this to say about the Textus Receptus,²² &ldquo;The T.R. is not a &lsquo;bad&rsquo; or misleading text, whether theologically or practically. Technically, however, it is far from the original text.&rdquo;²³ The King James was based on the Textus Receptus.²⁴</p>
<p><strong>What resources were used in the Inspired Version, the KJV, and The Berean Interlinear Bible)?</strong></p>
<p>The Inspired Version was downloaded from <a href="http://www.centerplace.org/hs/iv/">http://www.centerplace.org/hs/iv/</a>. The King James Version was downloaded from <a href="http://spreadsheetpage.com/index.php/file/king_james_bible/">http://spreadsheetpage.com/index.php/file/king_james_bible/</a> The Berean Interlinear Bible was downloaded from <a href="http://berean.bible/downloads.htm">http://berean.bible/downloads.htm</a>. Software, for noting the differences between the Inspired Version and the King James Version, was downloaded from <a href="https://www.diffchecker.com/diff">https://www.diffchecker.com/diff</a>. A hard copy of the Inspired Version was used to check for any differences in the downloaded Inspired Version. For each adjustment deference was given to the hard copy. A hard copy of the King James Bible was used to check for any differences in the downloaded King James Version. Again deference was given to the hard copy.</p>
<p><strong>Were there any changes to the three Scriptural documents? </strong></p>
<p>The Berean Interlinear Bible had Jesus&rsquo; words in red. It made it hard to read and the original Greek did not differentiate Jesus&rsquo; words in a different color. Jesus&rsquo; words were changed to a black font. Titles to portions of scripture passages were removed. The Interlinear has translated the Greek words into English words. The English words are hyperlinked to a web site for further understanding of the translation There are sixteen and one-half verses that were left blank in the Berean Interlinear Bible for lack of manuscript support (Mt. 6:13b, Mt. 17:21, Mt. 18:11, Mt. 23:14, Mk. 7:16, Mk. 9:44, Mk. 9:46, Mk. 11:26, Mk. 15:28, Lk. 17:36, Lk. 23:17, Jn. 5:4, Acts 8:37, Acts 8:37, Acts 15:34, Acts 24:7, Acts 28:29, and Rm. 16:24). Greek text was found in the footnotes in the Interlinear, but without any words of English equivalent. The Greek and English translation were added into the text itself. Because the passages are questionable, there are no hyperlinks to a web site. All footnotes were removed. No other changes were made to The Berean Interlinear Bible.</p>
<p>The downloaded King James Version was easier to format being in an Excel format. The drawback was what appeared to be in a British format using words like colour instead of color or theatre instead of theater. When there was a spelling difference between the Inspired Version and the King James Version, an American edition paper copy of the King James was consulted. Quite often the spelling would conform to what was in the Inspired Version. Joseph Smith had in all likelihood an American edition of the King James Version. The chapter and verse numbers were added to each verse to the downloaded version. Highlighting of words was also done. No other changes were made to the King James Version.</p>
<p>The Inspired version had the name of the book deleted from each verse (instead of &ldquo;John 3:8&rdquo; it would only be &ldquo;3:8&rdquo;). Joseph Smiths&rsquo; division of verses did not always line up with the order of the King James verses. For instance Matthew 1:2 in the Inspired Version is basically the same as Matthew 1:2 through Matthew 1:6a in the King James Version. The portions of verses were split up to show how they matched up to the King James Version rather than the other way around. The decision was not to relegate the Inspired Version to a standard below the King James Version. It would have been much harder dividing up the Greek text if the King James conformed to the format of the Inspired Version. The only other thing done was highlighting of words.</p>
<p><strong>What is with the highlight of words by using bold and underlining the text?</strong></p>
<p>If there were words used in one version but not in the other version, those words were highlighted. If the words were the same but in a different order in the verses, no highlighting would be used. There is a problem with this. If an adjective is modifying one noun but modifies a different noun in the opposing version, those words should technically be highlighted. But this might only be understood in the Greek. So the decision was made not to evaluate the words based on the Greek. Those decisions are being left up to the individual. Spelling changes would also be highlighted.</p>
<p>The earliest Greek manuscripts had all uppercase letters,²⁵ so changes in case between the two versions did not warrant highlighting. The early Greek manuscripts used few punctuation marks,²⁶ so punctuation differences between the two versions did not warrant highlighting. The early Greek manuscripts did not originally have chapter and verse numbers in the text. Robert Stephanus was the first to add chapter and verse numbers in 1551 for the New Testament and in 1571 for the Hebrew Bible.²⁷ Some comically add that he must have done it while riding on a horse which was jumpy at times.²⁸ So differences in the numbering of verses between the two versions did not warrant highlighting. As noted earlier there were no spaces between Greek words. But differences between the two versions in space or no space did indicate a change, although usually very minor. One version might use &ldquo;forever&rdquo; and the other version has &ldquo;for ever&rdquo;. Changes in spaces or with or without dashes (-) between words would have highlighting applied.</p>
<p><strong>Are there any limitations of the use of The Berean Interlinear Bible?</strong></p>
<p>The author of this document received permission to use this Greek Interlinear in full from the publisher.</p>
<p>The Holy Bible, Berean Interlinear Bible, BIB</p>
<p>Copyrighted &copy;2016 by Bible Hub</p>
<p>All rights Reserved Worldwide</p>
<p>Published by Bible Hub</p>
<p>Pittsburgh, PA 15045</p>
<p><a href="http://www.biblehub.com/">www.biblehub.com</a></p>
<p>The BIB text may be quoted in any form (written, visual, audio, or electronic) up to two thousand (2000) verses without written permission of the publisher.</p>
<p>Also without the requirement of written permission, you are free to make up to 200 copies of any portion of this text, or the full text itself, for personal use or free distribution in a church, ministry, or missions setting.</p>
<p>Notice of copyright must appear on the title page as follows:</p>
<p>Copyright &copy;2016 by Bible Hub<br /> Used by Permission. All Rights Reserved Worldwide.</p>
<p>Additionally, free licensing for use of the full text in software, apps, and websites is available through the following Berean Bible websites:</p>
<p><a href="http://www.Berean.Bible/">www.Berean.Bible</a> .......................... Berean Bible Homepage</p>
<p><a href="http://www.InterlinearBible.com/">www.InterlinearBible.com</a> ................ Berean Interlinear Bible (BIB)</p>
<p><a href="http://www.LiteralBible.com/">www.LiteralBible.com</a> ...................... Berean Literal Bible (BLB)</p>
<p><a href="http://www.BereanBible.com/">www.BereanBible.com</a> ......................Berean Study Bible (BSB)</p>
<p><a href="http://www.EmphasizedBible.com/">www.EmphasizedBible.com</a> .............. Berean Emphasized Bible (BEB)</p>
<p>Please direct further permissions and licensing inquiries to us through the contact page at one of the above websites.</p>
<p><strong>May God bless you as you do further study into His Word.</strong></p>
<p><strong>___________________</strong></p>
<p>1 Holy Bible: Berean Interlinear Bible (Pittsburgh, PA: Bible Hub,2016) December 15, 2017. <a href="http://berean.bible/downloads.htm">http://berean.bible/downloads.htm</a></p>
<p>2 Joseph Smith, <u>Joseph Smith&rsquo;s &ldquo;New Translation&rdquo; of the Bible</u> (Independence, MI: Hearld Publishing House, 1970)</p>
<p>3 J. Harold Greenlee, <u>Introduction to New Testament Textual Criticism</u> (Grand Rapids, MI: William B. Eerdmans Publishing Company, 1964), 12.</p>
<p>4 Paul D. Wegner, <u>The Journey from Texts to Translations: The Origin and Development of the Bible</u> (Grand Rapids, MI:1999), 225-226.</p>
<p>5 Norman L. Geisler and William E. Nix, <u>From God to Us: How We Got our Bible</u> (Chicago: Moody Press,1974), 177.</p>
<p>6 Wegner, 226.</p>
<p>7 &ldquo;Chester Beatty Papyri&rdquo; (Wikipedia: August 4, 2017), December 15, 2017. <a href="https://en.wikipedia.org/wiki/Chester_Beatty_Papyri">https://en.wikipedia.org/wiki/Chester_Beatty_Papyri</a></p>
<p>8 Greenlee, 34.</p>
<p>9 Bruce M. Metzger and Bart D. Ehrman, <u>The Text of the New Testament</u> (New York: Oxford University Press, 2005),. 55-56.</p>
<p>10 Greenlee, 16.</p>
<p>11 &ldquo;Bodmer Papyri&rdquo; (Wikipedia: November 16, 2017), December 15, 2017. <a href="https://en.wikipedia.org/wiki/Bodmer_Papyri">https://en.wikipedia.org/wiki/Bodmer_Papyri</a></p>
<p>12 Metger, 62-65.</p>
<p>13 &ldquo;Codex Sinaiticus&rdquo; December 15, 2017. <a href="http://www.codexsinaiticus.org/en/">http://www.codexsinaiticus.org/en/</a></p>
<p>14 Metger, 67-68.</p>
<p>15 &ldquo;Biblical Manuscript&rdquo; (Wikipedia: November 27, 2017), December 15, 2017. <a href="https://en.wikipedia.org/wiki/Biblical_manuscript">https://en.wikipedia.org/wiki/Biblical_manuscript</a></p>
<p>16 Wegner, 224.</p>
<p>17 Metger, p. 126.</p>
<p>18 Greenlee, p. 55.</p>
<p>19 Geisler, 181.</p>
<p>20 Ibid, pp. 184-186</p>
<p>21 Richard Lloyd Anderson, &ldquo;Manuscript Discoveries of the New Testament in Perspective&rdquo; in <u>Papers of the Fourteenth Annual Symposium on Archeology of the Scriptures</u>, ed. Forest R. Hauch (Salt Lake City: Brigham Young University Press, 1963), 58.</p>
<p>22 Greenlee, 70-72.</p>
<p>23 Ibid, 72.</p>
<p>24 Metzger, 327</p>
<p>25 Wegner, 210-211.</p>
<p>26 Ibid, 214; Metzger, 41.</p>
<p>27 &ldquo;Chapters and Verses of the Bible&rdquo; (Wikipedia: December 2, 2017), December 15, 2017. <a href="https://en.wikipedia.org/wiki/Chapters_and_verses_of_the_Bible">https://en.wikipedia.org/wiki/Chapters_and_verses_of_the_Bible</a></p>
<p>28 Wegner, 214.</p>
</body></html>
''';
