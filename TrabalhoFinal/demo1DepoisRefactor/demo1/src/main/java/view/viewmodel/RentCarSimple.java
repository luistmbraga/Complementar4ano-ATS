package view.viewmodel;
import exceptions.InvalidNewRental;
import model.Car;
import utils.Point;

public class RentCarSimple {
    private final Point point;
    private final Car.CarType type;

    public RentCarSimple(Point point, String type) throws InvalidNewRental {

        this.point = point;
        try {
            this.type = Car.CarType.valueOf(type.toLowerCase());
        }
        catch (IllegalArgumentException e){
            throw new InvalidNewRental();
        }
    }

    public Point getPoint() {
        return this.point;
    }

    public Car.CarType getCarType() {
        return this.type;
    }
}
