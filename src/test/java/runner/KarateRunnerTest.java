package runner;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.intuit.karate.Results;
import com.intuit.karate.StringUtils;
import com.intuit.karate.junit5.Karate;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;

import static org.apache.commons.lang3.StringUtils.defaultString;

public class KarateRunnerTest {

  static int requiredThreadsToRun() {
    final String threadsToRun = System.getProperty("threads");
    if (StringUtils.isBlank(threadsToRun)) {
      return 1;
    }
    return Integer.parseInt(threadsToRun);
  }

  static void generateReport(final String karateOutputPath) {
    final Collection jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
    final List jsonPaths = new ArrayList(jsonFiles.size());
    jsonFiles.forEach(file -> jsonPaths.add(file.toString()));
    final Configuration config = new Configuration(new File("target"), "ATG api tests task");
    final ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
    reportBuilder.generateReports();
  }

  @Karate.Test
  Karate runner() {
    final String karateEnv = defaultString(System.getProperty("TEST_ENV"), "local").toLowerCase();
    final Karate runner = Karate.run("classpath:features").karateEnv(karateEnv);
    final Results restResults = runner.outputCucumberJson(true).parallel(requiredThreadsToRun());
    generateReport(restResults.getReportDir());
    return runner;
  }

}
/*
https://petstore.swagger.io/v2/oauth/authorize?response_type=token&client_id=test&redirect_uri=CALLBACK_URL&scope=read
https://petstore.swagger.io/oauth/authorize?response_type=token&client_id=test&redirect_uri=https%3A%2F%2Fpetstore.swagger.io%2Foauth2-redirect.html&scope=read%3Apets%20write%3Apets&state=VGh1IE1hciAwMiAyMDIzIDIxOjAzOjU5IEdNVCswMDAwIChXZXN0ZXJuIEV1cm9wZWFuIFN0YW5kYXJkIFRpbWUp


https://oauth.example.com/token?grant_type=password&username=test&password=abc123&client_id=test


        Bearer f4a14088-23af-466a-a6e3-457e591d7811

        return { Authorization: 'Bearer f4a14088-23af-466a-a6e3-457e591d7811' };*/
