# Fed (Forked Execution Delegate)

**Fed (Forked Execution Delegate)** is a native multi-process execution framework designed for the Pharo Smalltalk environment.

While standard Pharo processes (`Process`) operate on a single OS thread using a green thread model, Fed leverages the **Clap command-line framework** to spawn external background processes using the exact same Pharo image file, allowing specified tasks to run in parallel as native OS processes.

## 🚀 Key Features

* **Execution via Clap**

  * Uses Clap command-line argument parsing to launch background Pharo instances from the same image file, assigning and executing specific tasks in dedicated processes.

* **OS-Level Native Parallelism**

  * Utilizes native OS execution mechanisms (posix_spawn() on Unix-likes and _spawnvp() on Windows (x64)).

  * Fully harnesses the performance of multi-core processors by distributing tasks across multiple native OS processes.

  * Even when a worker process blocks on file I/O or system operations, other processes continue running unimpeded.

* **Flexible Task Models**

  * Supports both one-shot task executions for quick, isolated runs and worker-pool architectures for long-lived worker management.

* **JSON-Based Inter-Process Communication**

  * Utilizes JSON serialization for passing parameters and returning task execution results between processes safely and flexibly.

* **LibC / FFI Integration**

  * Integrates with low-level C APIs via FFI (LibC) to support process control, signaling, and shared memory management.

## 📋 Requirements

* **Pharo**: Pharo 14.0 or later

* **OS**: Linux, macOS, or Windows (experimental)

## 📦 Installation

Open the **Playground** in Pharo and execute the following Metacello script to load the project:

```smalltalk
Metacello new
    baseline: 'Fed';
    repository: 'github://tomooda/Fed:main/src';
    load.
```

## 📄 License

MIT License
