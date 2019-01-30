import javafx.application.Application;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.util.Stack;

public class Main extends Application {

    Stage mainWindow;
    Scene firstScene, secondScene;
    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        mainWindow = primaryStage;

        Button goToSecondSceneButton = new Button("Go to second scene");
        goToSecondSceneButton.setOnAction(s -> mainWindow.setScene(secondScene));

        Button goToSecondWindowButton = new Button("Go to second window");
        goToSecondWindowButton.setOnAction(s -> AlertBox.display("eluwa","HI!"));

        Button exitButton = new Button("Exit");
        exitButton.setOnAction(s -> closeProgram());

        VBox layout1 = new VBox(50);
        layout1.getChildren().addAll(goToSecondSceneButton,goToSecondWindowButton,exitButton);
        layout1.setAlignment(Pos.CENTER);
        firstScene = new Scene(layout1,400,400);

        Button button2 = new Button("What is UP! GO back to 1 scene");
        button2.setOnAction(s -> mainWindow.setScene(firstScene));

        StackPane layout2 = new StackPane();
        layout2.getChildren().add(button2);
        secondScene = new Scene(layout2,500,500);


        mainWindow.setScene(firstScene);
        mainWindow.setTitle("JOJOJO");

        mainWindow.setOnCloseRequest(e -> {
            e.consume();
            closeProgram();
        });
        mainWindow.show();


    }

    private void closeProgram(){
        boolean storeAnswer = YesOrNoBox.close("Are you sure you want to close the Application?");
        if(storeAnswer)
            Platform.exit();
    }


}
