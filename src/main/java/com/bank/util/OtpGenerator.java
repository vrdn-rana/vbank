package com.bank.util;

import java.security.SecureRandom;
import org.springframework.stereotype.Component;

@Component
public class OtpGenerator {

    private static final SecureRandom random = new SecureRandom();

    public int generateOtp() {
        // Generates a 6-digit number between 100000 and 999999
        return 100000 + random.nextInt(900000);
    }
}