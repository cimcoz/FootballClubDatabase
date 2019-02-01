import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

public class ShowMessageWindow extends Main{
    public static void showMessege(String title, String message){
        Stage messageWindow = new Stage();
        messageWindow.initModality(Modality.APPLICATION_MODAL);
        messageWindow.setTitle(title);

        Label label = new Label(message);

        Button closeButton = new Button("Close");
        closeButton.setOnAction(e -> messageWindow.close());

        VBox layout = new VBox(20);
        layout.getChildren().addAll(label,closeButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout,100,50);
        messageWindow.setScene(scene);
        messageWindow.showAndWait();
    }
    public static void showMessageAndChangeScene(String title, String message, Scene sceneToChange){
        Stage messageWindow = new Stage();
        messageWindow.initModality(Modality.APPLICATION_MODAL);
        messageWindow.setTitle(title);

        Label label = new Label(message);

        Button closeButton = new Button("Close");
        closeButton.setOnAction(e -> {
            messageWindow.close();
            mainWindow.setScene(sceneToChange);
        });

        VBox layout = new VBox(20);
        layout.getChildren().addAll(label,closeButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout,100,50);
        messageWindow.setScene(scene);
        messageWindow.showAndWait();
    }
}
