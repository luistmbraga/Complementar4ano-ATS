



import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;     // bad smell -> duplicate import mas já corrigido

public class Parser {
    private List<String> file;

    private static final Logger LOGGER = Logger.getLogger(Parser.class.getName());

    public Parser() {
        this.file = new ArrayList<>();
    }

    public Parser(String db, UMCarroJa model) {
        try {
            this.file = Files
                    .readAllLines(Paths.get(db), StandardCharsets.UTF_8)
                    .stream()
                    .map(String::trim)
                    .filter(s -> !s.startsWith("--"))
                    .filter(s -> s.contains(":") && s.contains(","))
                    .map(e -> {
                        try {
                            return this.parseLine(e, model);
                        } catch (NoSuchAlgorithmException ex) {
                            LOGGER.warning(ex.toString());
                        }
                        return e;
                    })
                    .collect(Collectors.toList());
        } catch (IOException e) {
            //e.printStackTrace(); -> VULNERABILITY Throwable.printStackTrace(...) should not be called
            // utiliza o logger que é melhor mas devia de ser fatal em vez de warning
            LOGGER.warning(e.toString());
        }
    }

    private String parseLine(String l, UMCarroJa model) throws NoSuchAlgorithmException {
        String[] pLine = l.split(":");
        String categoria = pLine[0];
        String[] content = pLine[1].split(",");
        try {
            switch (categoria) {
                case "NovoProp":
                    if (content.length != 4)
                        break;
                    model.addUser(new Owner(
                            content[2],
                            content[0],
                            content[3],
                            Integer.parseInt(content[1]),
                            content[2]
                    ));
                    break;
                case "NovoCliente":
                    if (content.length != 6)
                        break;
                    model.addUser(new Client(
                            new Point(Double.parseDouble(content[4]), Double.parseDouble(content[5])),
                            content[2],
                            content[2],
                            content[0],
                            content[3],
                            Integer.parseInt(content[1])
                    ));
                    break;
                case "NovoCarro":
                    if (content.length != 10) {
                        break;
                    }
                    model.addCar(
                            content[2],
                            new StringBuilder()
                                    .append(content[3])
                                    .append("@gmail.com")
                                    .toString(),
                            Car.CarType.fromString(content[0]),
                            Double.parseDouble(content[4]),
                            Double.parseDouble(content[5]),
                            Double.parseDouble(content[6]),
                            Integer.parseInt(content[7]),
                            new Point(Double.parseDouble(content[8])
                                    , Double.parseDouble(content[9])),
                            content[1]
                    );
                    break;
                case "Aluguer":
                    if (content.length != 5)
                        break;
                    alugerRental(model,content);        // código dentro do try foi feito refactoring para uma outra função
                    break;
                case "Classificar":
                    if (content.length != 2)
                        break;
                    model.rate(content[0], Integer.parseInt(content[1]));
                    break;
                default:        // bad smell devia de ter default case
                    LOGGER.warning("Invalido");
                    break;
            }
        }
        catch (InvalidUserException
                | UserExistsException
                | CarExistsException
                | UnknownCarTypeException
                | InvalidCarException ignored) {
            LOGGER.warning(ignored.toString());
        }
        return l;
    }

    private void alugerRental(UMCarroJa model, String[] content){ // AluguerRental -> aluguerRental
        try {
            model.rental(new StringBuilder()
                            .append(content[0])
                            .append("@gmail.com")
                            .toString(),
                    new Point(Double.parseDouble(content[1])
                            , Double.parseDouble(content[2])),
                    content[4], Car
                            .CarType
                            .fromString(content[3]));
        } catch (NoCarAvaliableException | UnknownCarTypeException |
                UnknownCompareTypeException | NoSuchAlgorithmException |
                InvalidUserException e) {
            LOGGER.warning(e.toString());
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || this.getClass() != o.getClass()) return false;

        Parser parser = (Parser) o;
        return this.file.equals(parser.file);
    }

    // CORRIGIDO MINOR BUG -> OVERRIDE EQUALS TAMBÉM DEVERIA FAZER OVERRIDE DO HASHCODE
    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
