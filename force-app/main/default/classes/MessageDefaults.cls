public class MessageDefaults implements TestFactory.FieldDefaults{
	public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Message'
        };
    }
}