import Controller.Controller;
import Model.Parser;
import Model.UMCarroJa;

import java.io.IOException;


public class Main {
    public static void main(String[] args) {
        UMCarroJa model = new UMCarroJa();
        try {
            model = UMCarroJa.read(".tmp");
            System.out.println("adasdsada1");
        }
        catch (IOException | ClassNotFoundException e) {
            System.out.println("adasdsada2");
            new Parser("db/(0)log.txt", model);
        }
        try { Thread.sleep(10000);} catch (Exception e) {}
        new Controller(model).run();
        try {
            model.save(".tmp");
        }
        catch (IOException ignored) {}
    }
}
