import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;

import java.sql.PreparedStatement;

public class EditFansData extends Main{

    public static Scene EditFansDataScene(String lastNameVal, String firstNameVal,String personalVal,String cityVal,
                                   String streetVal,String emailVal,String birthdayVal){

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));
        grid.setVgap(8);
        grid.setHgap(10);


        Label messageLabel = new Label("Edit your Data:");
        Label lastNameLabel = new Label("Last name:");
        Label firstNameLabel = new Label("First name:");
        Label cityLabel = new Label("City:");
        Label streetLabel = new Label("Street:");
        Label emailLabel = new Label("E-mail:");
        Label birthdayLabel = new Label("Birthday date:");

        //inputs
        TextField lastNameInput = new TextField(lastNameVal);
        TextField firstNameInput = new TextField(firstNameVal);
        TextField cityInput = new TextField(cityVal);
        TextField streetInput = new TextField(streetVal);
        TextField emailInput = new TextField(emailVal);
        TextField birthdayInput = new TextField(birthdayVal);

        //Set in GridPane
        GridPane.setConstraints(lastNameLabel,0,1);
        GridPane.setConstraints(firstNameLabel,0,2);
        GridPane.setConstraints(cityLabel,0,3);
        GridPane.setConstraints(streetLabel,0,4);
        GridPane.setConstraints(emailLabel,0,5);
        GridPane.setConstraints(birthdayLabel,0,6);
        GridPane.setConstraints(lastNameInput,1,1);
        GridPane.setConstraints(firstNameInput,1,2);
        GridPane.setConstraints(cityInput,1,3);
        GridPane.setConstraints(streetInput,1,4);
        GridPane.setConstraints(emailInput,1,5);
        GridPane.setConstraints(birthdayInput,1,6);

        grid.getChildren().addAll(lastNameLabel,firstNameLabel,cityLabel,streetLabel,emailLabel,birthdayLabel,lastNameInput,
                firstNameInput,cityInput,streetInput,emailInput,birthdayInput);

        //BUTTONS
        Button goBackButton = new Button("Back");
        goBackButton.setOnAction(e -> mainWindow.setScene(LoggedUser.loggedUserScene(emailVal,personalVal)));

        Button editAccountData = new Button("Edit");
        editAccountData.setOnAction(e -> updateDataInDatabase(lastNameInput.getText(),firstNameInput.getText(), personalVal ,cityInput.getText(), streetInput.getText(),
                emailInput.getText(),  birthdayInput.getText()));

        HBox buttons = new HBox(10);
        buttons.getChildren().addAll(editAccountData,goBackButton);
        buttons.setAlignment(Pos.CENTER);

        GridPane.setConstraints(buttons,1,7);
        grid.getChildren().add(buttons);


        Scene scene = new Scene(grid,500,500);
        return scene;
    }
    private  static void updateDataInDatabase(String lastName, String firstName, String personalID , String city, String street, String mail, String bday){
        try {
            PreparedStatement st = conn.prepareStatement("EXEC edytuj_informacje_kibica(?,?,?,?,?,?,?,?) ");
            st.setString(1, lastName);
            st.setString(2, firstName);
            st.setString(3, personalID);
            st.setString(4, city);
            st.setString(5, street);
            st.setString(6, mail);
            st.setString(7, bday);
            st.executeUpdate();
            ShowMessageWindow.showMessageAndChangeScene("", "You've changed your data successfully!", LoggedUser.loggedUserScene(mail,personalID));
        }catch(Exception e) {
            ShowMessageWindow.showMessege("Error","Sorry. There is an error in database.");
            e.printStackTrace();
        }

    }
}
