package [base.package].[dominio];

import com.intuit.karate.junit5.Karate;

class [Domain]Runner {

    @Karate.Test
    Karate runDomain() {
        return Karate.run().relativeTo(getClass())
                .tags("~@wip");
    }
}
