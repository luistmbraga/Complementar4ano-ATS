// refactor para corrigir bad smell de Controller -> controller



import java.io.FileWriter;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class Controller {
    private final UMCarroJa model;
    private User user;
    private final Menu menu;

    private static final Logger LOGGER = Logger.getLogger(Parser.class.getName());

    public Controller(UMCarroJa model) {
        this.menu = new Menu();
        this.model = model;
    }

    public void run() throws IOException {
        String error = "";
        // bad smell reduzir a repetição da string "Parametros Inválidos"
        String paraminvalidos = "Parametros Inválidos";
        String nocarsav = "No cars availables";
        while(this.menu.getRun()) {
            long start, finish, timeElapsed;
            switch (menu.getMyind()) {
                case LOGIN:
                    try {
                        NewLogin r = menu.newLogin(error);
                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        double[] before = EnergyCheckUtils.getEnergyStats();
                        user = model.logIn(r.getUser(), r.getPassword());
                        // Medir fim da energia
                        double[] after = EnergyCheckUtils.getEnergyStats();

                        FileWriter myWriter = new FileWriter("resultados.txt",true);
                        myWriter.append("Dados de energia para o login:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();
                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");


                        menu.selectOption((user instanceof Client)? Menu.MenuInd.CLIENT : Menu.MenuInd.OWNER);
                        error = "";
                    }
                    catch (InvalidUserException e){ error = "Invalid Username"; }
                    catch (WrongPasswordExecption e){ error = "Invalid Password"; } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                case REGISTERCLIENT:
                    try {
                        RegisterUser registerUserCli = menu.newRegisterUser(error);
                        Client client = new Client(
                                registerUserCli.getPos(),
                                registerUserCli.getEmail(),
                                registerUserCli.getPasswd(),
                                registerUserCli.getName(),
                                registerUserCli.getAddress(),
                                registerUserCli.getNif()
                        );

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        double[] before = EnergyCheckUtils.getEnergyStats();

                        this.model.addUser(client);

                        // Medir fim da energia
                        double[] after = EnergyCheckUtils.getEnergyStats();

                        FileWriter myWriter = new FileWriter("resultados.txt",true);
                        myWriter.append("Dados de energia para o registo do cliente:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        menu.back();
                        error = "";
                    }
                    catch (InvalidNewRegisterException e){ error = paraminvalidos; }
                    catch (UserExistsException e){ error = "Utilizador já existe"; } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                case REGISTEROWNER:
                    try {
                        RegisterUser registerUserProp = menu.newRegisterUser(error);
                        Owner owner = new Owner(
                                registerUserProp.getEmail(),
                                registerUserProp.getName(),
                                registerUserProp.getAddress(),
                                registerUserProp.getNif(),
                                registerUserProp.getPasswd()
                        );

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        double[] before = EnergyCheckUtils.getEnergyStats();

                        this.model.addUser(owner);

                        // Medir fim da energia
                        double[] after = EnergyCheckUtils.getEnergyStats();

                        FileWriter myWriter = new FileWriter("resultados.txt",true);
                        myWriter.append("Dados de energia para o registo do proprietário:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        menu.back();
                        error = "";
                    }
                    catch (InvalidNewRegisterException e){ error = paraminvalidos; }
                    catch (UserExistsException e){ error = "Utilizador já existe"; } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                case CLOSEST:
                    // medir inicio do tempo
                    start = System.currentTimeMillis();
                    // medir energia
                    double[] before = EnergyCheckUtils.getEnergyStats();

                    error = getClosestOuCheapest(error, nocarsav, "MaisPerto");

                    // Medir fim da energia
                    double[] after = EnergyCheckUtils.getEnergyStats();

                    FileWriter myWriter = new FileWriter("resultados.txt",true);
                    myWriter.append("Dados de energia para a determinação do carro mais próximo:\n");
                    myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                    myWriter.close();

                    // medir fim do tempo
                    finish = System.currentTimeMillis();

                    timeElapsed = finish - start;
                    System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");
                    break;
                case CHEAPEST:
                    // medir inicio do tempo
                    start = System.currentTimeMillis();
                    // medir energia
                    before = EnergyCheckUtils.getEnergyStats();

                    error = getClosestOuCheapest(error, nocarsav, "MaisBarato");

                    // Medir fim da energia
                    after = EnergyCheckUtils.getEnergyStats();

                    myWriter = new FileWriter("resultados.txt", true);
                    myWriter.append("Dados de energia para a determinação do carro mais barato:\n");
                    myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                    myWriter.close();

                    // medir fim do tempo
                    finish = System.currentTimeMillis();

                    timeElapsed = finish - start;
                    System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                    break;
                case REVIEWRENTAL:
                    Owner owner = (Owner)this.user;
                    CopyOnWriteArrayList<Rental> lR = (CopyOnWriteArrayList<Rental>) owner.getPending();
                    if (lR.isEmpty()){      // smell estava lR.size == 0 -> lR.isEmpty()
                        this.menu.back();
                        break;
                    }
                    String v = menu.reviewRentShow(
                            error,
                            owner.getRates(),
                            lR.stream()
                                    .map(Rental::toParsableUserString)
                                    .map(x -> Arrays.asList(x.split("\n")))
                                    .collect(Collectors.toList()));

                    try {
                        switch (v.charAt(0)) {
                            case 'a':
                                this.model.rent(lR.get(Integer.parseInt(v.substring(1)) - 1));
                                this.model.rate(
                                        owner,
                                        lR.get(Integer.parseInt(v.substring(1)) - 1),
                                        this.menu.showRentalRate(
                                                lR.get(Integer.parseInt(v.substring(1)) - 1).toFinalString()));
                                break;
                            case 'r':
                                this.model.refuse(owner, lR.get(Integer.parseInt(v.substring(1)) - 1));
                                break;
                            case 'b':
                                this.menu.back();
                                break;
                            default:        // faltava o default case aqui corrigido o smell
                                break;
                        }
                        error = "";
                    }
                    catch(NumberFormatException | IndexOutOfBoundsException | NoSuchAlgorithmException e){error = "Input Inválido";}
                    break;

                case CHEAPESTNEAR:
                    try{
                        CheapestNearCar walkCar = menu.walkingDistanceRent(error);

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        before = EnergyCheckUtils.getEnergyStats();

                        Rental rental = model.rental(
                                (Client)user,
                                walkCar.getPoint(),
                                walkCar.getWalkDistance(),
                                walkCar.getType()
                        );

                        // Medir fim da energia
                        after = EnergyCheckUtils.getEnergyStats();

                        myWriter = new FileWriter("resultados.txt", true);
                        myWriter.append("Dados de energia para a determinação do carro mais barato mais próximo:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        this.menu.showString(rental.toString());
                        this.menu.back();
                        error = "";
                    }
                    catch (InvalidNewRental e){error = "New rental inválido";}
                    catch (NoCarAvaliableException e)  {error = nocarsav; }
                    break;

                case AUTONOMY:
                    try{
                        AutonomyCar autoCar = menu.autonomyCarRent(error);

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        before = EnergyCheckUtils.getEnergyStats();

                        Rental rental = model.rental(
                                autoCar.getPoint(),
                                autoCar.getAutonomy(),
                                autoCar.getType(),
                                (Client)user);


                        // Medir fim da energia
                        after = EnergyCheckUtils.getEnergyStats();

                        myWriter = new FileWriter("resultados.txt", true);
                        myWriter.append("Dados de energia para o cálculo da autonomia:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        menu.showString(rental.toString());
                        this.menu.back();
                        error = "";
                    }
                    catch (InvalidNewRental e){error = "New rental inválido";}
                    catch (NoCarAvaliableException e) { error = nocarsav; }
                    break;

                case SPECIFIC:
                    try {
                        SpecificCar sc = this.menu.specificCarRent(error);

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        before = EnergyCheckUtils.getEnergyStats();

                        Rental rental = this.model.rental(sc.getPoint(), sc.getNumberPlate(), (Client)user);


                        // Medir fim da energia
                        after = EnergyCheckUtils.getEnergyStats();

                        myWriter = new FileWriter("resultados.txt", true);
                        myWriter.append("Dados de energia para a determinação de um carro específico:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        this.menu.showString(rental.toString());
                        this.menu.back();
                        error = "";
                    }
                    catch (NoCarAvaliableException e) { error = "Carro não está disponível"; }
                    catch (InvalidCarException e) { error = "Carro não existe"; }
                    catch (InvalidNewRental e) { error = "Invalid Parameters"; }
                    break;

                case ADDCAR:
                    try {
                        RegisterCar registerCar = menu.newRegisterCar(error);
                        Owner ownerCar = (Owner)this.user;

                        // medir inicio do tempo
                        start = System.currentTimeMillis();
                        // medir energia
                        before = EnergyCheckUtils.getEnergyStats();

                        model.addCar(
                                ownerCar,
                                registerCar.getNumberPlate(),
                                registerCar.getType(),
                                registerCar.getAvgSpeed(),
                                registerCar.getBasePrice(),
                                registerCar.getGasMileage(),
                                registerCar.getRange(),
                                registerCar.getPos(),
                                registerCar.getBrand()
                        );

                        // Medir fim da energia
                        after = EnergyCheckUtils.getEnergyStats();

                        myWriter = new FileWriter("resultados.txt", true);
                        myWriter.append("Dados de energia para adicionar um carro:\n");
                        myWriter.append("Energy consumption of dram: " + (after[0] - before[0])+ " Energy consumption of cpu: " + (after[1] - before[1])+ " Energy consumption of package: " + (after[2] - before[2]) + "\n\n");
                        myWriter.close();

                        // medir fim do tempo
                        finish = System.currentTimeMillis();

                        timeElapsed = finish - start;
                        System.out.println("Tempo de execucao: " + timeElapsed + " milisegundos");

                        menu.back();
                        error = "";
                    }
                    catch (InvalidNewRegisterException e){ error = paraminvalidos; }
                    catch (CarExistsException e){ error = "Carro já existe"; }
                    catch (InvalidUserException ignored) { LOGGER.warning(ignored.toString());}      // faltava fazer algo aqui
                    break;

                case NUSES:
                    menu.top10ClientsShow(
                            this.model.getBestClientsTimes()
                                    .stream()
                                    .map(x ->
                                            Arrays.asList(
                                                    x.getKey(),
                                                    x.getValue().toString()))
                                    .limit(10)
                                    .collect(Collectors.toList()),
                            "Número de Utilizações");
                    this.menu.back();
                    break;

                case DISTANCE:
                    menu.top10ClientsShow(
                            this.model.getBestClientsTravel()
                                    .stream()
                                    .map(x ->
                                            Arrays.asList(
                                                    x.getKey(),
                                                    String.format("%.2f", x.getValue())))
                                    .limit(10)
                                    .collect(Collectors.toList()),
                            "Distância");
                    this.menu.back();
                    break;

                case CAROVERVIEW:
                    Owner ownerCar = (Owner)this.user;
                    String action = this.menu.carOverviewShow(error,
                            ownerCar.getCars().stream()
                                    .map(x -> Arrays.asList(x.toString().split("\n")))
                                    .collect(Collectors.toList()));
                    try {
                        switch (action.charAt(0)) {
                            case ' ':
                                break;
                            case 'r':
                                model.refil(ownerCar, Integer.parseInt(action.substring(1)) - 1);
                                break;
                            case'c':
                                String [] s = action.substring(1).split(" ");
                                if (s.length != 2)
                                    throw new InvalidNumberOfArguments();
                                model.setBasePrice(ownerCar, Integer.parseInt(s[0]) - 1, Double.parseDouble(s[1]));
                                break;
                            case 'd':
                                model.swapState(ownerCar, Integer.parseInt(action.substring(1)) - 1);
                                break;
                            case 't':
                                TimeInterval ti = this.menu.getTimeInterval(error);
                                this.menu.showString("Total faturado: " +
                                        model.getTotalBilledCar(
                                                ownerCar.getCars().get(Integer.parseInt(action.substring(1)) - 1),
                                                ti.getInicio(),
                                                ti.getFim()));
                                break;
                            case 'b':
                                this.menu.back();
                                break;

                            default:
                                throw new InvalidNumberOfArguments();
                        }
                        error = "";
                    }
                    catch (IndexOutOfBoundsException e){ error = "Valor de carro inválido"; }
                    catch (NumberFormatException e){ error = "Posição inválida"; }
                    catch (InvalidNumberOfArguments e) {error = "Invalid parameters";}
                    catch (InvalidTimeIntervalException e ){error = "Formato Inválido de Data";}
                    break;

                case PENDING:
                    try {
                        Client cli = (Client) user;
                        List<Rental> pR = cli.getPendingRates();

                        if (pR.isEmpty()) {           // smell passar de pR.size() == 0 para pR.isEmpty()
                            this.menu.back();
                            break;
                        }

                        RateOwnerCar r = this.menu.pendingRateShow(error, pR.get(0).toString(), pR.size());

                        model.rate(cli, pR.get(0), r.getOwnerRate(), r.getCarRate());

                        error = "";
                    }
                    catch (InvalidRatingException e){error = paraminvalidos;}
                    break;

                case HISTORYOWNER:
                    try{
                        TimeInterval ti = this.menu.getTimeInterval(error);

                        this.menu.rentalHistoryShow(ti,
                                this.model.getRentalListOwner((Owner) this.user, ti.getInicio(), ti.getFim())
                                        .stream()
                                        .map(Rental::toParsableOwnerRentalString)
                                        .map(x -> Arrays.asList(x.split("\n")))
                                        .collect(Collectors.toList()));

                        this.menu.back();
                        error = "";
                    }
                    catch (InvalidTimeIntervalException e){error = "Intervalo Inválido";}
                    break;

                case HISTORYCLIENT:
                    try{
                        TimeInterval ti = this.menu.getTimeInterval(error);

                        this.menu.rentalHistoryShow(ti,
                                this.model.getRentalListClient((Client) this.user, ti.getInicio(), ti.getFim())
                                        .stream()
                                        .map(Rental::toParsableUserRentalString)
                                        .map(x -> Arrays.asList(x.split("\n")))
                                        .collect(Collectors.toList()));

                        this.menu.back();
                        error = "";
                    }
                    catch (InvalidTimeIntervalException e){error = "Intervalo Inválido";}
                    break;

                default:
                    this.menu.parser();
                    break;
            }
        }
    }

    private String getClosestOuCheapest(String error, String nocarsav, String maisPerto) {
        try {
            RentCarSimple rent = menu.simpleCarRent(error);
            Rental rental = model.rental(
                    (Client) user,
                    rent.getPoint(),
                    maisPerto,
                    rent.getCarType());
            menu.showString(rental.toString());
            menu.back();
            error = "";
        } catch (UnknownCompareTypeException ignored) {
            LOGGER.warning(ignored.toString());
        }    // corrigido aqui pq não tinha nada
        catch (NoCarAvaliableException e) {
            error = nocarsav;
        } catch (InvalidNewRental e) {
            error = "Novo Rental inválido";
        }
        return error;
    }
}
