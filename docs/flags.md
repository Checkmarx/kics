## Flags
KICS scan flags are defined on `kics-flags.json` and `scan-flags.json`, that can be found on `console/assets` directory.

The structure of a flag on JSON definition should use the following structure:
```json
{
    "flagName": {
        "flagType": "<multiStr|str|bool|int>The type of the flag",
        "shorthandFlag": "<optional>Shorthand for the flag, MUST be one character only",
        "defaultValue": "The default value of the flag, MUST be string or null",
        "usage": "Usage description of the flag, can use variables, which is described below"
    }
}
```

Example of a valid `flags.json` file:
```json
{
    "no-progress": {
        "flagType": "bool",
        "shorthandFlag": "",
        "defaultValue": "false",
        "usage": "hides the progress bar"
    },
    "output-path": {
        "flagType": "str",
        "shorthandFlag": "o",
        "defaultValue": "",
        "usage": "directory path to store reports"
    },
    "type": {
        "flagType": "multiStr",
        "shorthandFlag": "t",
        "defaultValue": "",
        "usage": "case insensitive list of platform types to scan\n(${supportedPlatforms})"
    }
}
```

## Hidden and Deprecated Flags
To mark a flag as hidden use the following configuration:
```json
{
  "disable-full-descriptions": {
    "flagType": "bool",
    "shorthandFlag": "",
    "defaultValue": "false",
    "usage": "disable request for full descriptions and use default vulnerability descriptions",
    "hidden": true
  }
}
```

If you also want to display a flag deprecation warning you can define it like this:

```json
{
  "disable-full-descriptions": {
    "flagType": "bool",
    "shorthandFlag": "",
    "defaultValue": "false",
    "usage": "disable request for full descriptions and use default vulnerability descriptions",
    "hidden": true,
    "deprecated": true,
    "deprecatedInfo": "use --disable-full-descriptions instead"
  }
}
```

## Flag types
As described above you should describe which type is the flag, currently there is 4 flags types:
- str: Represents a string type;
- int: Represents an integer type;
- bool: Represents a boolean type;
- multiStr: Represents a string slice type, this receives multiple strings comma-separated;

This type is used to cast `defaultValue` field and to determine which map it will be saved.

## Accessing and setting flags
If you want to access flag, you should use get functions and the name of the flag. Currently there are 4 get functions:
- `getStrFlag(flagName)`: Returns a string value of requested flag;
- `getIntFlag(flagName)`: Returns a integer value of requested flag;
- `getBoolFlag(flagName)`: Returns a boolean value of requested flag;
- `getMultiStrFlag(flagName)`: Returns a slice of strings of requested flag;

You can also set a flag value, using set functions. Currently there are 2 set functions:
- `setStrFlag(flagName)`: Sets a flag with string value;
- `setMultiStrFlag(flagName)`: Sets a flag with slice of strings value;

## Usage variables
Usage field has a special function that replace variables found in this field, using the syntax `${variable}`. If a variable is listed when evaluating usage, it will replace it with this text. Currently there are 3 variables supported:
- `sliceInstructions`: A constant with instructions for slice flags;
- `supportedPlatforms`: The result of `ListSupportedPlatforms` function converted to string, which gets all KICS supported platforms;
- `supportedProviders`: The result of `ListSupportedCloudProviders` function converted to string, which gets all KICS supported providers;

You can add variables by modifying `variables` map on `evalUsage` function of flags.go file.
