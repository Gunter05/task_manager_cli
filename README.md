# 📋 Task Manager CLI (Dart)

Application en ligne de commande (CLI) de gestion de tâches développée en Dart pur.

## 🎯 Objectifs & Exigences Techniques

Ce projet met en œuvre les principes fondamentaux de la programmation orientée objet (POO) et d'une architecture logicielle propre :

- **Héritage et Polymorphisme** : Structure de classes évolutive (`Task` → `UrgentTask`).
- **Interfaces et Génériques** : Implémentation du pattern `Repository<T>` et du contrat `JsonEncodable`.
- **Gestion Avancée des Erreurs** : Exceptions personnalisées typées (`TaskNotFoundException`, `InvalidTaskDataException`).
- **Persistance I/O Asynchrone** : Manipulation sécurisée des fichiers JSON via `dart:io` et `dart:convert`.

## 🚀 Fonctionnalités
- **Gestion des tâches** : Ajout (simples ou urgentes avec date limite), modification de statut, suppression.
- **Trier** : Par priorité (Haute, Moyenne, Basse) ou par date limite.
- **Persistance des données** : Sauvegarde automatique au format JSON dans `data/tasks.json`.
- **Architecture POO** : Utilisation de classes abstraites, d'héritage (`Task` -> `UrgentTask`), de génériques (`Repository<T>`) et d'exceptions personnalisées.

## 🏗️ Architecture du Projet
 
Le projet respecte une séparation stricte des responsabilités (SOC) :
 
```text
task_manager_cli/
├── bin/
│   └── task_manager_cli.dart       # Point d'entrée principal (initialisation et boucle CLI)
├── lib/
│   ├── exceptions/                 # Exceptions personnalisées
│   │   └── task_exceptions.dart
│   ├── models/                     # Modèles de données & abstractions
│   │   ├── json_encodable.dart
│   │   ├── priority.dart
│   │   ├── simple_task.dart
│   │   ├── task.dart
│   │   └── urgent_task.dart
│   ├── repository/                 # Pattern Repository & stockage JSON
│   │   ├── json_task_repository.dart
│   │   └── repository.dart
│   └── services/                   # Service métier et contrôleur d'interface CLI
│       ├── cli_service.dart
│       └── task_manager_service.dart
├── test/                           # Tests unitaires
│   └── task_manager_test.dart
├── data/                           # Stockage local des données
│   └── tasks.json
├── pubspec.yaml                    # Spécification Dart & dépendances
└── README.md                       # Documentation officielle
```

## 💾 Structure des Données (`data/tasks.json`)
 
Les tâches sont sérialisées sous forme de tableau JSON avec gestion du type d'objet pour le polymorphisme :
 
```json
[
  {
    "id": "1712345678901",
    "title": "Préparer la présentation d'architecture",
    "priority": "high",
    "isCompleted": false,
    "type": "urgent",
    "deadline": "2026-08-15T00:00:00.000"
  },
  {
    "id": "1712345678902",
    "title": "Acheter un câble réseau Cat6",
    "priority": "medium",
    "isCompleted": true
  }
]
```

## 🛠️ Prérequis
- [Dart SDK](https://dart.dev/get-dart) (v3.0.0 ou supérieure)

## 💻 Installation & Exécution
 
### 1. Cloner le dépôt et accéder au dossier
 
```bash
git clone https://github.com/votre-compte/task_manager_cli.git
cd task_manager_cli
```
 
### 2. Télécharger les dépendances
 
```bash
dart pub get
```
 
### 3. Lancer l'application CLI
 
```bash
dart run bin/task_manager_cli.dart
```