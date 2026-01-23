# Quickstart: Domain Model in Bingo.Core

**Feature**: 002-domain-model-bingo-core  
**Last Updated**: 2025-01-23

## Overview

This guide covers building and testing the Bingo.Core domain model project.

## Prerequisites

- .NET SDK 10 (pinned via `global.json` in repo root)
- Repository cloned and on branch `002-domain-model-bingo-core`

## Project Structure

```text
src/Bingo.Core/              # Domain model project
  ├── Entities/              # Domain entities
  ├── Enums/                 # Value objects (enums)
  └── Bingo.Core.csproj      # Project file

tests/Bingo.Core.Tests/      # Unit tests
  └── Bingo.Core.Tests.csproj
```

## Build

From repository root:

```bash
dotnet build src/Bingo.Core/Bingo.Core.csproj
```

Or build the entire solution:

```bash
dotnet build
```

## Test

Run domain model unit tests:

```bash
dotnet test tests/Bingo.Core.Tests/Bingo.Core.Tests.csproj
```

Or run all tests:

```bash
dotnet test
```

## Using the Domain Model

### Example: Creating a Game Template

```csharp
using Bingo.Core.Entities;
using Bingo.Core.Enums;

// Create tiles
var tiles = new List<TemplateTile>();
for (int i = 1; i <= 75; i++)
{
    var tileResult = TemplateTile.Create(i, $"Tile {i}");
    if (tileResult.IsSuccess)
    {
        tiles.Add(tileResult.Value);
    }
}

// Create template
var templateResult = GameTemplate.Create("Classic Bingo", tiles);

if (templateResult.IsSuccess)
{
    var template = templateResult.Value;
    Console.WriteLine($"Created template: {template.Name} with {template.Tiles.Count} tiles");
}
else
{
    Console.WriteLine($"Error: {templateResult.Error}");
}
```

### Example: Managing Game Session Lifecycle

```csharp
// Create a new draft session
var session = GameSession.Create(template.Id);

Console.WriteLine($"Session status: {session.Status}"); // Draft

// Start the session
var startResult = session.Start();
if (startResult.IsSuccess)
{
    Console.WriteLine($"Session status: {session.Status}"); // Active
}

// End the session
var endResult = session.End();
if (endResult.IsSuccess)
{
    Console.WriteLine($"Session status: {session.Status}"); // Ended
}
```

### Example: Creating and Marking a Board

```csharp
// Select 25 random tiles for a board
var random = new Random();
var boardTiles = template.Tiles
    .OrderBy(_ => random.Next())
    .Take(25)
    .ToList();

// Create board
var boardResult = Board.Create(session.Id, boardTiles, playerId: "Player1");

if (boardResult.IsSuccess)
{
    var board = boardResult.Value;
    
    // Mark a cell
    var cellToMark = board.Cells[0]; // First cell
    var markResult = board.MarkCell(cellToMark.Id);
    
    if (markResult.IsSuccess)
    {
        Console.WriteLine("Cell marked successfully");
    }
}
```

## Key Patterns

### Result<T> Pattern

All domain operations that can fail return `Result<T>`:

```csharp
var result = GameTemplate.Create(name, tiles);

if (result.IsSuccess)
{
    // Access the value
    var template = result.Value;
}
else
{
    // Handle the error
    Console.WriteLine(result.Error);
}
```

### Invariant Enforcement

Domain objects enforce business rules at construction:

```csharp
// This will fail - no tiles
var invalidResult = GameTemplate.Create("Empty", new List<TemplateTile>());
Debug.Assert(invalidResult.IsFailure);

// This will fail - empty name
var invalidResult2 = GameTemplate.Create("", tiles);
Debug.Assert(invalidResult2.IsFailure);
```

### Immutable Collections

Domain entities expose read-only collections:

```csharp
var template = GameTemplate.Create("Test", tiles).Value;

// This works - reading
var count = template.Tiles.Count;

// This won't compile - cannot modify
// template.Tiles.Add(newTile); // Compile error: IReadOnlyList<T>
```

## Running with the Full Application

The domain model project is referenced by:
- `Bingo.Api`: API layer (Epic 3)
- `Bingo.Data`: Persistence layer (Epic 2 / Story 3)

Once implemented, you can run the full application using Aspire:

```bash
aspire run --project src/Bingo.AppHost/Bingo.AppHost.csproj
```

The domain model will be used internally by the API and data layers.

## Testing

### Running All Tests

```bash
# From repo root
dotnet test

# With detailed output
dotnet test --logger "console;verbosity=detailed"

# With coverage (if configured)
dotnet test --collect:"XPlat Code Coverage"
```

### Running Specific Tests

```bash
# Single test class
dotnet test --filter FullyQualifiedName~GameTemplateTests

# Single test method
dotnet test --filter FullyQualifiedName~GameTemplateTests.Create_WithValidData_Succeeds
```

## CI Integration

The domain model is automatically built and tested in CI:

1. **Build step**: `dotnet build` includes `Bingo.Core`
2. **Test step**: `dotnet test` includes `Bingo.Core.Tests`
3. **Validation**: CI fails if:
   - Any project doesn't build
   - Any test fails
   - Any `PackageReference` has `Version=` attribute

## Troubleshooting

### Build Errors

**Problem**: "Cannot find type 'Result'"

**Solution**: Implement or add the Result<T> helper class in `Bingo.Core/Common/Result.cs`

---

**Problem**: "The type or namespace name 'Core' does not exist"

**Solution**: Ensure you've added the project reference:
```bash
dotnet add src/Bingo.Api reference src/Bingo.Core
```

### Test Errors

**Problem**: Tests fail with "XUnit not found"

**Solution**: Ensure xUnit is in `Directory.Packages.props` and referenced in test project:
```xml
<ItemGroup>
  <PackageReference Include="xunit" />
  <PackageReference Include="xunit.runner.visualstudio" />
</ItemGroup>
```

---

**Problem**: "Test discovery failed"

**Solution**: Ensure test class is public and methods are marked with `[Fact]`:
```csharp
public class GameTemplateTests
{
    [Fact]
    public void Create_WithValidData_Succeeds()
    {
        // Test code
    }
}
```

## Next Steps

After completing this feature:

1. **Epic 2 / Story 2**: Implement board generation and bingo rules (win detection)
2. **Epic 2 / Story 3**: Add EF Core mappings for persistence
3. **Epic 3**: Build API endpoints that use the domain model

## Reference

- **Spec**: `specs/002-domain-model-bingo-core/spec.md`
- **Data Model**: `specs/002-domain-model-bingo-core/data-model.md`
- **Research**: `specs/002-domain-model-bingo-core/research.md`
