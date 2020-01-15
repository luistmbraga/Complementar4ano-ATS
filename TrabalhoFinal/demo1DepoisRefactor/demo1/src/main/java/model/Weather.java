package model;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Random;

class Weather {

    // definidas estas strings de modo a não estar a repetir tantas vezes Winter, Summer, .... -> code smell
    private static final String WINTER = "Winter";
    private static final String SPRING = "Spring";
    private static final String SUMMER = "Summer";
    private static final String FALL = "Fall";

    private static final String[] seasons = {
            WINTER, WINTER,
            SPRING, SPRING, SPRING,
            SUMMER, SUMMER, SUMMER,
            FALL, FALL, FALL,
            WINTER
    };

    private Random rand = SecureRandom.getInstanceStrong();

    Weather() throws NoSuchAlgorithmException {
    }

    private String getSeason() {
        return seasons[LocalDateTime.now().getMonthValue()];
    }

    // POSSUI CRITICAL BUG DEVERIA DE GUARDAR O RANDOM E USAR SECURE RANDOM -> CORRIGIDO O CRITICAL BUG DESTA MANEIRA
    public double getSeasonDelay() {
        Double a = this.rand.nextDouble();
        switch (getSeason()){
            case SUMMER:
                return a % 0.1;

            case SPRING:
                return a % 0.3;

            case FALL:
                return a % 0.35;

            default:
                return a % 0.6;
        }
    }

    // CORRIGIDOS OS 2 CRITICALS BUGS TANTO NO WEATHER COMO NO TRAFFIC RELACIONADOS COM RANDOM
}

