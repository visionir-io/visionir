import polars as pl
from pydantic import BaseModel, Json

polars_pydantic_schema = {
    float: pl.Float64,
    "integer": pl.Int64,
    "string": pl.Utf8,
    "null": pl.Utf8,
    "boolean": pl.Boolean,
    BaseModel: pl.Struct,
}


def transform_model_to_polars_scheme(model: Json) -> dict[str, pl.DataType]:
    model_fields = model["properties"]
    polars_schema = {}
    for field, field_props in model_fields.items():
        field_type = field_props.get("type")
        if field_type:
            try:
                polars_schema[field] = polars_pydantic_schema[field_type]
            except KeyError:
                msg = f"Type {field_type} not supported in the schema"
                print(msg)
                raise KeyError(msg)
        elif field_props.get("$ref"):
            polars_schema[field] = polars_pydantic_schema[BaseModel]
        else:
            print(f"Field to convert schema, {field} not presented type or ref")
    return polars_schema


if __name__ == "__main__":
    from integrations.wakatime.models.user import User
    import polars as pl

    polars_schema = transform_model_to_polars_scheme(User.model_json_schema())
    df = pl.DataFrame(schema=polars_schema)
    print(polars_schema)
