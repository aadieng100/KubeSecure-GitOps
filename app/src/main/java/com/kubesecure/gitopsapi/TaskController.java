package com.kubesecure.gitopsapi;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

interface TaskRepository extends JpaRepository<Task, Long> {
}

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskRepository repository;

    public TaskController(TaskRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return repository.findAll();
    }

    @PostMapping
    public Task createTask(@Valid @RequestBody Task task) {
        return repository.save(task);
    }
}
