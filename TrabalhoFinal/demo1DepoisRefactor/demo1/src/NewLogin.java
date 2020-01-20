
public class NewLogin {
    // code smell -> devia de estar em minúsculo
    private final String user;
    private final String password;

    public NewLogin(String user, String password) {
        this.user = user;
        this.password = password;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }
}
