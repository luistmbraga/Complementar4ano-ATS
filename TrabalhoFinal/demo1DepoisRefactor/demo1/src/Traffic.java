

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Random;

class Traffic {

    // DEPOIS DO REFACTORING GUARDA O RANDOM E UTULIZA O SECURE RANDOM QUE É MAIS PREFERÍVEL ->
    // CORRIGIU CRITICAL BUG
    private Random rand = SecureRandom.getInstanceStrong();

    Traffic() throws NoSuchAlgorithmException {
    }

    public double getTraficDelay(double delay) {
        int a = LocalDateTime.now().getHour();
        double b = this.rand.nextDouble();
        if(a == 18 || a == 8)
            return (b % 0.6) + (b % 0.2);
        if(a > 1 && a < 6)
            return (b % 0.1) + (delay % 0.2);
        return (b % 0.3) + (delay % 0.2);
    }

}
