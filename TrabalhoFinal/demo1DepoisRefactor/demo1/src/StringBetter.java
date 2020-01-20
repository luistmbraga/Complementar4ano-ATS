
public class StringBetter{
    private String str;

    public StringBetter() {
        this.str = "";
    }

    public StringBetter(String str) {
        this.str = str;
    }

    public String getStr() {
        return str;
    }

    // smell -> removido o método setStr nunca utilizado

    public StringBetter repeat(int n){
        StringBuilder s = new StringBuilder();
        for(int i = 0; i < n; i++)
            s.append(this.str);
        return new StringBetter(s.toString());
    }

    public StringBetter append(String strA){
        this.str += strA;
        return this;
    }

    public StringBetter black() {
        return new StringBetter("\033[30m" + this.str).reset();
    }

    public StringBetter red() {
        return new StringBetter("\033[31m" + this.str).reset();

    }

    public StringBetter green() {
        return new StringBetter("\033[32m" + this.str).reset();

    }

    public StringBetter orange() {
        return new StringBetter("\033[33m" + this.str).reset();

    }

    public StringBetter blue() {
        return new StringBetter("\033[34m" + this.str).reset();

    }

    public StringBetter roxo() {
        return new StringBetter("\033[35m" + this.str).reset();

    }

    public StringBetter cyan() {
        return new StringBetter("\033[36m" + this.str).reset();

    }

    public StringBetter grey(){
        return new StringBetter("\033[37m" + this.str).reset();

    }

    public StringBetter white() {
        return new StringBetter( "\033[38m" + this.str).reset();

    }

    public StringBetter bold() {
        return new StringBetter("\033[1m" + this.str).reset();

    }

    public StringBetter under(){
        return new StringBetter("\033[4m" + this.str).reset();

    }

    // smell -> RESET passou para reset
    private StringBetter reset(){
        return new StringBetter(this.str + "\033[0m");
    }

    @Override
    public String toString() {
        return this.str;
    }
}
