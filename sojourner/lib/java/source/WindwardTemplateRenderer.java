import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;
import net.windward.datasource.dom4j.Dom4jDataSource;
import net.windward.xmlreport.ProcessPdf;
import net.windward.xmlreport.ProcessReport;

/**
 * Wrapper to render documents using Windward Java Engine.
 *
 * See lib/tasks/java.rake for details on how to build.
 */
public class WindwardTemplateRenderer {
    public static String license;

    private InputStream template;

    public WindwardTemplateRenderer(InputStream template) {
        this.template = template;
    }

    public void render(InputStream xmlData, OutputStream output) throws Exception {
        System.setProperty("license", WindwardTemplateRenderer.license);

        ProcessReport.init();

        ProcessPdf proc = new ProcessPdf(this.template, output);
        proc.processSetup();

        Dom4jDataSource dataSource = new Dom4jDataSource(xmlData);
        proc.processData(dataSource, "");

        proc.processComplete();
    }
}
