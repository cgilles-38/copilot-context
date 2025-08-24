# Contexte COP (Instance)

Ce dossier provient du modÃ¨le COP.

## Usage rapide
1. Nouveau prompt :
   powershell -ExecutionPolicy Bypass -File .\\Scripts\\Init-Prompt.ps1 -Title \"Titre\" -Stage
2. ComplÃ©ter COP/Summarize & COP/Result
3. Commit : git commit -m \"prompt: <ID> <titre>\"

## Structure
- Prompt.md : index + sections
- copilot-context.txt : contexte
- COP/Summarize : synthÃ¨ses
- COP/Result : rÃ©sultats
- Scripts/Init-Prompt.ps1 : gÃ©nÃ©ration
- Scripts/Test-PromptIntegrity-Light.ps1 : vÃ©rif basique (si prÃ©sent)

## RÃ¨gles
- ID immuable
- Pas de suppression (archiver)
- Sections standard conservÃ©es

Bonne utilisation.
