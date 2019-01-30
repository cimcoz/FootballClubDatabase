import javafx.geometry.Insets;
import javafx.scene.control.Label;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.util.Stack;
public class CreateNewAccountScene extends Main{
    public static  Scene changeToCreateAccountScene() {
        Label titleLabel = new Label("Create new account");

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));
        grid.setVgap(8);
        grid.setHgap(10);

        //labes:
        Label lastNameLabel = new Label("Last name:");
        Label firstNameLabel = new Label("First name:");
        Label personalIdLabel = new Label("Personal ID:");
        Label cityLabel = new Label("City:");
        Label streetLabel = new Label("Street:");
        Label emailLabel = new Label("E-mail:");
        Label birthdayLabel = new Label("Birthday date:");


        //inputs
        TextField lastNameInput = new TextField();
        TextField firstNameInput = new TextField();
        TextField personalIDInput = new TextField();
        TextField cityInput = new TextField();
        TextField streetInput = new TextField();
        TextField emailInput = new TextField();
        TextField birthdayInput = new TextField();

        //putting on gridpane
        GridPane.setConstraints(lastNameLabel,0,0);
        GridPane.setConstraints(firstNameLabel,0,1);
        GridPane.setConstraints(personalIdLabel,0,2);
        GridPane.setConstraints(cityLabel,0,3);
        GridPane.setConstraints(streetLabel,0,4);
        GridPane.setConstraints(emailLabel,0,5);
        GridPane.setConstraints(birthdayLabel,0,6);
        GridPane.setConstraints(lastNameInput,1,0);
        GridPane.setConstraints(firstNameInput,1,1);
        GridPane.setConstraints(personalIDInput,1,2);
        GridPane.setConstraints(cityInput,1,3);
        GridPane.setConstraints(streetInput,1,4);
        GridPane.setConstraints(emailInput,1,5);
        GridPane.setConstraints(birthdayInput,1,6);
        birthdayInput.setPromptText("yyyy-mm-dd");

        grid.getChildren().addAll(lastNameLabel,firstNameLabel,personalIdLabel,cityLabel,streetLabel,emailLabel,birthdayLabel,lastNameInput,
                                    firstNameInput,personalIDInput,cityInput,streetInput,emailInput,birthdayInput);

        Button goBackButton = new Button("Back");
        GridPane.setConstraints(goBackButton,0,7);
        goBackButton.setOnAction(e -> goBackToPreviousScene());
        grid.getChildren().add(goBackButton);

        Scene createAccountScene = new Scene(grid,500,500);
        return createAccountScene;
    }
    private static void goBackToPreviousScene(){
        mainWindow.setScene(loginScene);
    }


}
/*
     imie nvarchar (64) NOT NULL ,
     nazwisko NVARCHAR (64) NOT NULL ,
     pesel NVARCHAR (10) NOT NULL ,
     miasto NVARCHAR (64) NOT NULL ,
     ulica NVARCHAR (64) NOT NULL ,
     email NVARCHAR (64) ,
     data_urodzenia DATE NOT NULL,
     znizka float
*/