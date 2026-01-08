import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event: dict, context: dict) -> dict:
    """Обрабатывает HTTP запрос от API Gateway.
    
    Args:
        event: Событие от API Gateway с HTTP запросом
        context: Контекст выполнения функции
        
    Returns:
        Словарь с HTTP ответом (statusCode, headers, body)
    """
    try:
        logger.info(f"Received event: {json.dumps(event)}")
        
        # Пример обработки запроса
        method = event.get("httpMethod", "GET")
        path = event.get("path", "/")
        
        response_body = {
            "message": "Hello from Yandex Cloud Function",
            "method": method,
            "path": path,
        }
        
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
            },
            "body": json.dumps(response_body, ensure_ascii=False),
        }
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
            },
            "body": json.dumps({"error": "Internal server error"}),
        }
