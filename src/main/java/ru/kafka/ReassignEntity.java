package ru.kafka;

import lombok.Data;

import java.util.List;

@Data
public class ReassignEntity {

    private List<Topic> topics;
    private String verison = "1";

}
