package optimizadorenvios.usuarios;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class UsuariosRunner {

    @Test
    void testUsuarios() {
        Results results = Runner.path("classpath:optimizadorenvios/usuarios")
                .tags("~@wip")
                .outputCucumberJson(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
