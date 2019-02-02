import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;

import java.sql.PreparedStatement;

public class ExtendTicketValidity extends  Main{
    public static Scene extendTicketValidityScene(String usrname, String pswd){
        Scene scene = setScene(usrname, pswd);
        scene.getStylesheets().add("Style.css");
        return scene;
    }
    private static Scene setScene(String usrname, String pswd){
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));
        grid.setVgap(8);
        grid.setHgap(10);

        Label lastNameLabel = new Label("Select how many days you want to extend your ticket:");
        ChoiceBox<String> ticketValidityBox = new ChoiceBox<>();
        ticketValidityBox.getItems().addAll("30","60","180","360");
        ticketValidityBox.setValue("30");

        Button extendButton = new Button("Extend");
        extendButton.setOnAction(s -> extendTicketValidityInDatabase(usrname,pswd,ticketValidityBox.getValue()));

        Button backButton = new Button("Back");
        backButton.setOnAction(e -> mainWindow.setScene(LoggedUser.loggedUserScene(usrname, pswd)));

        HBox buttons = new HBox(10);
        buttons.getChildren().addAll(extendButton,backButton);
        buttons.setAlignment(Pos.CENTER);

        GridPane.setConstraints(lastNameLabel,0,0);
        GridPane.setConstraints(ticketValidityBox,1,0);
        GridPane.setConstraints(buttons,1,1);
        grid.getChildren().addAll(lastNameLabel,ticketValidityBox,buttons);
        return (new Scene(grid,500,500));

    }
    private static void extendTicketValidityInDatabase(String usrname, String pswd, String time){
        try {
            int days = Integer.parseInt(time);
            PreparedStatement st = conn.prepareStatement("EXEC przedluz_karnet ?,?,? ");
            st.setString(1, pswd);
            st.setString(2,usrname);
            st.setInt(3,days);
            st.executeUpdate();
            ShowMessageWindow.showMessege("", "You've changed your ticket's validity  successfully!");
            mainWindow.setScene(LoggedUser.loggedUserScene(usrname,pswd));
        }catch(Exception e) {
            ShowMessageWindow.showMessege("Error","Sorry. There is an error in database.");
            e.printStackTrace();
        }
    }
}
