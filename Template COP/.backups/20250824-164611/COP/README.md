# COP (Modèle)

Structure de traçabilité des prompts.

Dossiers:
- `Summarize/` : synthèse en continu
- `Result/` : bilan final

ID: `PROMPT-YYYYMMDD-HHMM-NN`

Fichier summary modèle:
```
# <ID> - <Titre>
Date/Heure : <horodatage>
Type : Summary

## Intent utilisateur
## Réponse stratégie assistant
## Échanges clés
## Décisions / Arbitrages
## Livrables / Actions réalisées
## Suivi / Prochaines étapes
```

Fichier result modèle:
```
# <ID> - <Titre>
Date/Heure : <horodatage>
Type : Result

## Objet du prompt
## Livrables tangibles
## Effets / Impact
## Points en suspens
## Liens / Références croisés
```

Checklist rapide:
1. ID unique ajouté dans Prompt.md
2. Fichiers summary/result créés
3. Sections présentes
4. Summary <= 40 lignes
5. Contexte mis à jour si règles changent
