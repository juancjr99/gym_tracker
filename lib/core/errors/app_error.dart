import 'package:equatable/equatable.dart';

/// Clase base para todos los errores de la aplicación
abstract class AppError extends Equatable implements Exception {
  const AppError(this.message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

/// Error de servidor
class ServerError extends AppError {
  const ServerError([super.message = 'Error del servidor']);
}

/// Error de conexión
class NetworkError extends AppError {
  const NetworkError([super.message = 'Error de conexión']);
}

/// Error de cache/base de datos local
class CacheError extends AppError {
  const CacheError([super.message = 'Error de almacenamiento local']);
}

/// Error de validación
class ValidationError extends AppError {
  const ValidationError([super.message = 'Error de validación']);
}

/// Error de autenticación
class AuthenticationError extends AppError {
  const AuthenticationError([super.message = 'Error de autenticación']);
}

/// Error de autorización
class AuthorizationError extends AppError {
  const AuthorizationError([super.message = 'No autorizado']);
}

/// Error cuando no se encuentra un recurso
class NotFoundError extends AppError {
  const NotFoundError([super.message = 'Recurso no encontrado']);
}

/// Error desconocido
class UnknownError extends AppError {
  const UnknownError([super.message = 'Error desconocido']);
}