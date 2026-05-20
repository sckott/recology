---
name: wdl-notes
layout: post
title: "Workflow Description Language Notes"
date: 2026-03-02
author: Scott Chamberlain
tags:
  - wdl
  - workflow
  - bioinformatics
---

Where I work at the [Fred Hutch Cancer Center](https://fredhutch.org/) folks use a variety of tools to run bioinformatics workflows (i.e. "workflow managers") - one of those is the Workflow Description Language (WDL).

I work on some internal tooling using WDL for Fred Hutch folks, and thought it would be helpful to document my notes here.

Note that I'm a newcomer to bioinformatics ...

## What is WDL?

WDL is a domain-specific language for describing data processing workflows. It was originally developed at the Broad Institute but has since become an open standard managed by the [OpenWDL community](https://openwdl.org/).

The core idea is simple: you define **tasks** (individual computational steps) and **workflows** (how those tasks connect together). A basic WDL file looks something like this:

```wdl
version 1.0

task hello {
    input {
        String name
    }
    command {
        echo "Hello, ~{name}!"
    }
    output {
        String greeting = read_string(stdout())
    }
}

workflow say_hello {
    input {
        String person
    }
    call hello { input: name = person }
    output {
        String message = hello.greeting
    }
}
```

The syntax is fairly readable - you can see the inputs, what command gets run, and what outputs are produced. See [the docs](https://docs.openwdl.org/) for more details.

## Why use WDL?

Here are some reasons you might want to reach for WDL:

- **Reproducibility**: WDL workflows are declarative. You describe _what_ you want, not _how_ to do it. This makes it easier to reproduce analyses across different compute environments.
- **Portability**: WDL separates the workflow logic from the execution environment. The same WDL can run on your laptop, an HPC cluster, or in the cloud.
- **Modularity**: Tasks are reusable. You can compose complex workflows from simple building blocks.
- **Strong typing**: WDL has a type system that catches errors before runtime. Inputs and outputs are explicitly declared.
- **Cloud-native**: Several major cloud platforms have good support for running WDL workflows (Terra, DNAnexus, AWS HealthOmics, etc.).

## Why NOT use WDL?

WDL isn't always the right choice:

- **Learning curve**: It's another language to learn. If your workflows are simple shell scripts, WDL might be overkill.
- **Ecosystem size**: Compared to Nextflow or Snakemake, the WDL ecosystem is smaller. Fewer community workflows, tutorials, and Stack Overflow answers.
- **Development tooling**: IDE support and debugging tools aren't as mature as general-purpose languages.
- **Execution complexity**: You need a separate execution engine to run WDL files. You can't just run them directly.
- **Bioinformatics focus**: While WDL is general-purpose in theory, in practice most resources and examples are bioinformatics-focused.

## Tools for Running WDL

WDL is just a specification - you need an execution engine to actually run workflows. Here are the main options:

### Cromwell

[Cromwell](https://github.com/broadinstitute/cromwell) is the reference implementation, developed by the Broad Institute. It's written in Scala/Java and is the most feature-complete engine.

- Supports local execution, HPC clusters (SLURM, SGE, etc.), and cloud backends (Google Cloud, AWS, Azure)
- Has a server mode for managing many workflows
- Heavyweight - requires Java and can be resource-intensive

### miniwdl

[miniwdl](https://github.com/chanzuckerberg/miniwdl) is a lightweight alternative from the Chan Zuckerberg Initiative.

- Written in Python
- Faster startup, lower resource usage
- Great for local development and testing
- Supports local and AWS execution

### Sprocket

[Sprocket](https://sprocket.bio/) is a newer, high-performance workflow engine built specifically for bioinformatics.

- Modern, open-source engine focused on speed and efficiency
- Runs on Windows, macOS, and Linux
- Supports local execution, HPC clusters, and cloud backends (AWS, Google Cloud, Azure)
- Designed for the "develop locally, run at scale" workflow - test on your laptop, then scale to thousands of parallel workflows

### Other Options

- **Terra**: A cloud platform (built on Cromwell) popular in genomics research
- **DNAnexus**: Commercial platform with WDL support
- **AWS HealthOmics**: AWS's managed service for bioinformatics workflows

## Comparison to Nextflow and Snakemake

Two other workflow managers are Nextflow and Snakemake.

**Nextflow** is probably the most popular choice in bioinformatics. It's more flexible than WDL but that flexibility comes with complexity. The nf-core community maintains hundreds of production-quality pipelines.

**Snakemake** uses Python-like syntax which makes it accessible if you already know Python. It uses a Makefile-like approach where you define rules based on file patterns.

**WDL** sits in the middle - more structured than Nextflow, but not as immediately familiar as Snakemake's Python syntax. Its strength is in portability and the strong type system.

## Comparison to R/Python Workflow Tools

To give a touchpoint for folks coming from R or Python that are not familiar with workflow managers, tools like `targets` (formerly `drake`) in R or Prefect/Airflow in Python are similar to WDL/Nextflow/Snakemake at a high level.

R is focused on working in R, while the Python examples below are often associated with web dashboards backed by companies, where Python is often the primary language used to orchestrate it's data pipelines. In both of these languages, the tools are primarily designed to use just that one language (R or Python). In proper workflow managers like WDL/Nextflow/Snakemake, tasks can run any programming language.

### R: targets

The `targets` package is excellent for R-centric analytical workflows. Key differences:

- **Scope**: `targets` is designed for R workflows. WDL is language-agnostic - each task can run any command.
- **Compute**: `targets` runs in a single R session (with some parallelism). WDL workflows run each task in isolated containers (e.g., Docker or Apptainer).
- **Portability**: `targets` workflows are tied to R. WDL workflows can run anywhere with a compatible engine.
- **Use case**: Use `targets` for R analysis pipelines. Use WDL when you need to orchestrate diverse tools across distributed compute.

### Python: Prefect, Airflow, etc.

Python has many workflow tools ([Prefect][prefect], [Airflow][airflow], [Luigi][luigi], [Dagster][dagster]). These are typically:

- **More general-purpose**: Built for ETL, data engineering, ML pipelines
- **Tightly coupled to Python**: Tasks are Python functions
- **Infrastructure-heavy**: Often require databases, web servers, etc.

WDL is more focused on batch scientific computing. Each task runs a command (which could call Python, R, or anything else) in a container. It's less about orchestrating Python code and often about orchestrating command-line tools.

## Final Thoughts

WDL is a solid choice if you need portable, reproducible scientific workflows, especially if you're working in an environment that already uses it (like many genomics groups). The type system and structured approach help catch errors early.

That said, if you're just starting out, the ecosystem around Nextflow or Snakemake is larger and might be easier to get help with. And if your workflows are purely R or Python, staying within those ecosystems (`targets`, Prefect, etc.) might be simpler.

## Links

- [OpenWDL](https://openwdl.org/) - The official WDL community site
- [WDL Documentation](https://docs.openwdl.org/) - Language specification and guides
- [Cromwell](https://github.com/broadinstitute/cromwell) - Reference execution engine
- [miniwdl](https://github.com/chanzuckerberg/miniwdl) - Lightweight Python-based engine
- [Sprocket](https://sprocket.bio/) - High-performance modern engine
- [WDL Best Practices](https://docs.openwdl.org/en/stable/WDL/Best_Practices/) - Style guide and recommendations

---

_Earlier drafts of this post included input by Claude Opus 4.5._

[prefect]: https://prefect.io/
[airflow]: https://airflow.apache.org/
[luigi]: https://luigi.readthedocs.io/en/stable/
[dagster]: https://dagster.io/
