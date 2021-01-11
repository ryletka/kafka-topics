package ru.kafka;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {

    private static final String GENERATE = "generate";
    private static final String EXECUTE = "execute";
    private static final String JAR_PATH;

    static {
        String path = Main.class.getProtectionDomain().getCodeSource().getLocation().getPath();
        JAR_PATH = path.substring(0, path.lastIndexOf("/") + 1);
    }

    public static void main(String[] args) throws Exception {
        String mode = args[0];
        if (GENERATE.equals(mode)) {
            String pathToTopics = args[1];
            int topicsPerFile = Integer.parseInt(args[2]);
            generate(pathToTopics, topicsPerFile);
        } else if (EXECUTE.equals(mode)) {
            int fileCount = Integer.parseInt(args[1]);
            execute(fileCount);
        } else {
            throw new IllegalArgumentException();
        }
    }

    private static void createReassignFile(String pathName, String serializedData) throws Exception {
        File generateFile = new File(pathName);
        Path path = Paths.get(pathName);

        generateFile.getParentFile().mkdirs();
        Files.write(path, serializedData.getBytes(StandardCharsets.UTF_8), StandardOpenOption.CREATE_NEW);
    }

    private static ReassignEntity generateReassignEntity(List<String> list) {
        ReassignEntity generateEntity = new ReassignEntity();
        List<Topic> topics = new ArrayList<>();
        list.forEach(el -> {
            Topic topic = new Topic();
            topic.setTopic(el);
            topics.add(topic);
        });
        generateEntity.setTopics(topics);
        return generateEntity;
    }

    private static void generate(String pathToTopics, int topicsPerFile) throws Exception {
        File file = new File(JAR_PATH + pathToTopics);

        List<String> list = new ArrayList<>();
        Scanner sc = new Scanner(file);
        int i = 1;
        int fileNumber = 0;
        while (sc.hasNextLine()) {
            if (i % topicsPerFile == 0) {
                ReassignEntity reassignEntity = generateReassignEntity(list);
                i = 0;
                fileNumber++;
                String pathName = JAR_PATH + "/generate" + fileNumber + ".json";
                String serializedData = JsonUtil.serialize(reassignEntity);
                createReassignFile(pathName, serializedData);
                list = new ArrayList<>();
            }
            list.add(sc.nextLine());
            i++;
        }
        if (!list.isEmpty()) {
            ReassignEntity reassignEntity = generateReassignEntity(list);
            String pathName = JAR_PATH + "/generate" + ++fileNumber + ".json";
            String serializedData = JsonUtil.serialize(reassignEntity);
            createReassignFile(pathName, serializedData);
        }
    }

    private static void execute(int executeFileCount) throws Exception {
        for (int i = 1; i <= executeFileCount; i++) {
            String pathName = JAR_PATH + "/generated/generated" + i + ".txt";
            File file = new File(pathName);
            Scanner sc = new Scanner(file);
            boolean writeToRollback = false;
            boolean writeToExecute = false;
            String executePathName = JAR_PATH + "/execute/execute" + i + ".json";
            String rollbackPathName = JAR_PATH + "/rollback/rollback" + i + ".json";
            StringBuilder executeContent = new StringBuilder();
            StringBuilder rollbackContent = new StringBuilder();
            while (sc.hasNextLine()) {
                String nextLine = sc.nextLine();
                if (writeToRollback) {
                    rollbackContent.append(nextLine);
                }
                if (writeToExecute) {
                    executeContent.append(nextLine);
                }
                if (nextLine.equals("Current partition replica assignment")) {
                    writeToRollback = true;
                }
                if (nextLine.equals("Proposed partition reassignment configuration")) {
                    writeToExecute = true;
                    writeToRollback = false;
                }
            }
            createReassignFile(executePathName, executeContent.toString());
            createReassignFile(rollbackPathName, rollbackContent.toString());
        }
    }

}
