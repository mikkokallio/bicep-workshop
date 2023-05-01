# Bicep workshop

This is a 1-day workshop to illustrate the fundamental concepts and syntax of Bicep, and to learn how deploy resources with Bicep templates on the command-line.

## Target architecture

![Target architecture](https://github.com/mikkokallio/bicep-workshop/blob/main/images/architecture.png)

The above picture shows most of the resources used in the hands-on exercises. Additionally, a storage account is deployed.

## Contents

- [Unit 0: Preparations](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_0.md)
- [Unit 1: Create, modify, and destroy resources](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_1.md)
- [Unit 2: Refactor code to improve maintainability](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_2.md)
- [Unit 3: Modular re-use](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_3.md)
- [Unit 4: Extra exercises](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_4.md)

# After the workshop

When you're done, you can delete the resource group that you used for deploying resources. That removes not only the rg but also any resources.

# To be checked
- What's this: The configuration value of bicep.use_binary_from_path has been set to 'false'.
- Anatomy of template/module, slide vs article. Symbolic names vs Azure names, etc.
