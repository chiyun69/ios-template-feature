# ``template_feature``

### Características Principales

- **Separación de Responsabilidades**: Cada capa tiene una responsabilidad específica
- **Regla de Dependencias**: Las dependencias apuntan hacia adentro (Presentation → Domain → Data)
- **Testabilidad**: Cada capa puede ser probada independientemente
- **Encapsulación**: Solo la carpeta Public expone APIs externas
- **Agnóstico de Plataforma**: La capa Domain permanece como lógica de negocio pura
- **Escalabilidad**: La estructura soporta crecimiento sin cambios disruptivos

### Notas de Uso:

- La capa Domain nunca debe depender de las capas Data o Presentation
- Los ViewModels en la capa Presentation solo deben depender de los UseCases del Domain
- Todo acceso externo pasa a través de la API de la carpeta Public
- La configuración de DI conecta todo internamente
- Los Resources tienen alcance de módulo para evitar conflictos

## Estructura del Framework

### Capa Domain (`template-feature/Domain/`)

La capa de dominio contiene la lógica de negocio y define las entidades principales del sistema:

- **Models/**: Entidades de dominio (`Quote.swift`). Modelos de negocio centrales independientes de la capa de datos. Clases/estructuras de datos puras sin dependencias del framework
- **Repositories/**: Interfaces de repositorio que definen operaciones de datos. Abstrae la implementación de la capa de datos del dominio
- **UseCases/**: Operaciones de lógica de negocio con responsabilidad única. Cada caso de uso representa una acción de negocio. Orquesta llamadas a repositorios y reglas de negocio

### Capa Data (`template-feature/Data/`)

La capa de datos implementa los repositorios y maneja la obtención de datos:

- **Repositories/**: Implementaciones concretas de las interfaces de repositorio del dominio. Coordina entre fuentes de datos y proporciona datos a la capa de dominio
- **RemoteDataSource/API/**: Definiciones de endpoints de API y llamadas de red
- **DTO/**: Objetos de Transferencia de Datos para comunicación con API. Modelos de datos crudos que coinciden con la estructura del backend
- **Mappers/**: Transforma DTOs a modelos de dominio y viceversa. Aísla la capa de dominio de cambios en la API

### Capa Presentation (`template-feature/Presentation/`)

La capa de presentación contiene la interfaz de usuario y la lógica de presentación:

- **Screens/**: Pantallas organizadas por funcionalidad
  - **QuoteScreen/**: Pantalla principal de citas
    - **Components/**: Componentes reutilizables específicos de la pantalla
- Cada pantalla incluye:
  - Vista SwiftUI principal
  - ViewModel con lógica de presentación
  - State para manejo de estados de la UI

### Inyección de Dependencias (`template-feature/DI/`)

Módulos de configuración de dependencias:

- **QuoteModule.swift**: Configuración y registro de dependencias
- Define cómo se resuelven las dependencias entre capas

### API Pública (`template-feature/Public/`)

Punto de entrada público del framework:

- **QuoteModuleAPI.swift**: API expuesta para integración externa
- Define la interfaz pública del módulo

### Recursos (`template-feature/Resources/`)

Recursos compartidos del framework:

- **TemplateFeatureResources.swift**: Configuración de recursos (imágenes, localizaciones, etc.)

## Patrones de Desarrollo

### 1. Arquitectura por Capas

Sigue el principio de dependencias unidireccionales:
```
Presentation → Domain ← Data
```

### 2. Protocolos para Testabilidad

Todas las dependencias se definen mediante protocolos:

- `QuoteRepository` (Domain)
- `ZenQuotesAPIServiceProtocol` (Data)
- `QuoteMapperProtocol` (Data)
- `GetTodayQuoteUseCaseProtocol` (Domain)

### 3. ViewModels con Estados

Los ViewModels manejan estados explícitos:

```swift
enum QuoteScreenState: Equatable {
    case idle
    case loading
    case loaded(Quote)
    case error(String)
}
```

### 4. Casos de Uso

Encapsulan lógica de negocio específica:

```swift
final class GetTodayQuoteUseCase: GetTodayQuoteUseCaseProtocol {
    func execute() async throws -> Quote
}
```

## Cómo Crear Nuevas Funcionalidades

### Paso 1: Definir la Entidad de Dominio

Crear el modelo en `Domain/Models/`:

```swift
struct NuevaEntidad: Equatable {
    let id: String
    let nombre: String
}
```

### Paso 2: Crear el Repositorio

Definir el protocolo en `Domain/Repositories/`:

```swift
protocol NuevaEntidadRepository {
    func obtenerEntidades() async throws -> [NuevaEntidad]
}
```

### Paso 3: Implementar el Repositorio

En `Data/Repositories/`:

```swift
final class NuevaEntidadRepositoryImpl: NuevaEntidadRepository {
    private let apiService: NuevaEntidadAPIServiceProtocol
    private let mapper: NuevaEntidadMapperProtocol
    
    func obtenerEntidades() async throws -> [NuevaEntidad] {
        // Implementación
    }
}
```

### Paso 4: Crear el Caso de Uso

En `Domain/UseCases/`:

```swift
protocol ObtenerEntidadesUseCaseProtocol {
    func execute() async throws -> [NuevaEntidad]
}

final class ObtenerEntidadesUseCase: ObtenerEntidadesUseCaseProtocol {
    private let repository: NuevaEntidadRepository
    
    func execute() async throws -> [NuevaEntidad] {
        return try await repository.obtenerEntidades()
    }
}
```

### Paso 5: Crear la Pantalla

En `Presentation/Screens/NuevaPantalla/`:

1. **State**: Define los estados de la UI
2. **ViewModel**: Maneja la lógica de presentación
3. **View**: Interfaz SwiftUI
4. **Components/**: Componentes reutilizables

### Paso 6: Configurar Dependencias

Actualizar `DI/QuoteModule.swift` para registrar las nuevas dependencias.

### Paso 7: Crear Tests

Para cada componente, crear tests correspondientes en `template-featureTests/`:

- Tests de modelo (Domain)
- Tests de casos de uso (Domain)
- Tests de repositorio (Data)
- Tests de mapper (Data)
- Tests de ViewModel (Presentation)

## Ejecución de Pruebas Unitarias

### Opción 1: Usando Xcode (Recomendado)

1. Abrir `template-feature.xcodeproj` en Xcode
2. Presionar `⌘+U` para ejecutar todas las pruebas
3. Ver resultados en el navigator de pruebas

### Opción 2: Línea de Comandos

```bash
# Ejecutar todas las pruebas
xcodebuild test -scheme template-feature -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'

# Ejecutar pruebas específicas
xcodebuild test -scheme template-feature -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' -only-testing:template-featureTests/QuoteTests

# Limpiar y ejecutar pruebas
xcodebuild clean && xcodebuild test -scheme template-feature -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'
```

### Cobertura de Pruebas

El framework incluye **26 pruebas unitarias** que cubren:

- ✅ **QuoteTests** (5 pruebas): Inicialización y comparación de modelos
- ✅ **GetTodayQuoteUseCaseTests** (2 pruebas): Casos de éxito y error
- ✅ **QuoteRepositoryImplTests** (3 pruebas): Integración con API y manejo de errores
- ✅ **QuoteMapperTests** (5 pruebas): Conversión de DTOs a entidades
- ✅ **ZenQuotesAPIServiceTests** (5 pruebas): Comunicación con API externa
- ✅ **QuoteScreenViewModelTests** (6 pruebas): Estados de UI y operaciones asíncronas

### Configuración de Pruebas

Para que las pruebas funcionen correctamente:

1. El framework debe tener `ENABLE_TESTABILITY = YES` en configuración Debug
2. Usar `@testable import template_feature` en archivos de prueba
3. Implementar mocks usando protocolos para testabilidad





