package optimizadorenvios;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class AllRunner {

    @Test
    void testAll() {
        Results results = Runner.path("classpath:optimizadorenvios")
                .tags("~@wip")
                .outputCucumberJson(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
