import { User } from '../../../../src/domain/user/entity';

describe('User Entity', () => {
  const validUserProps = {
    id: 'user-123',
    email: 'test@example.com',
    name: 'Test User',
  };

  describe('create', () => {
    it('should create a user with active status', () => {
      const user = User.create(validUserProps);

      expect(user.id).toBe(validUserProps.id);
      expect(user.email).toBe(validUserProps.email);
      expect(user.name).toBe(validUserProps.name);
      expect(user.status).toBe('active');
      expect(user.isActive).toBe(true);
    });

    it('should set timestamps on creation', () => {
      const before = new Date();
      const user = User.create(validUserProps);
      const after = new Date();

      expect(user.createdAt.getTime()).toBeGreaterThanOrEqual(before.getTime());
      expect(user.createdAt.getTime()).toBeLessThanOrEqual(after.getTime());
    });
  });

  describe('update', () => {
    it('should update name', () => {
      const user = User.create(validUserProps);
      const updated = user.update({ name: 'New Name' });

      expect(updated.name).toBe('New Name');
      expect(updated.email).toBe(validUserProps.email);
    });

    it('should update email', () => {
      const user = User.create(validUserProps);
      const updated = user.update({ email: 'new@example.com' });

      expect(updated.email).toBe('new@example.com');
    });

    it('should update updatedAt timestamp', () => {
      const user = User.create(validUserProps);
      const originalUpdatedAt = user.updatedAt;

      // 약간의 지연 후 업데이트
      const updated = user.update({ name: 'New Name' });

      expect(updated.updatedAt.getTime()).toBeGreaterThanOrEqual(
        originalUpdatedAt.getTime()
      );
    });
  });

  describe('deactivate', () => {
    it('should change status to inactive', () => {
      const user = User.create(validUserProps);
      const deactivated = user.deactivate();

      expect(deactivated.status).toBe('inactive');
      expect(deactivated.isActive).toBe(false);
    });

    it('should throw error if already inactive', () => {
      const user = User.create(validUserProps);
      const deactivated = user.deactivate();

      expect(() => deactivated.deactivate()).toThrow('User is already inactive');
    });
  });

  describe('activate', () => {
    it('should change status to active', () => {
      const user = User.create(validUserProps);
      const deactivated = user.deactivate();
      const activated = deactivated.activate();

      expect(activated.status).toBe('active');
      expect(activated.isActive).toBe(true);
    });

    it('should throw error if already active', () => {
      const user = User.create(validUserProps);

      expect(() => user.activate()).toThrow('User is already active');
    });
  });

  describe('toJSON', () => {
    it('should return all properties', () => {
      const user = User.create(validUserProps);
      const json = user.toJSON();

      expect(json).toHaveProperty('id', validUserProps.id);
      expect(json).toHaveProperty('email', validUserProps.email);
      expect(json).toHaveProperty('name', validUserProps.name);
      expect(json).toHaveProperty('status', 'active');
      expect(json).toHaveProperty('createdAt');
      expect(json).toHaveProperty('updatedAt');
    });
  });
});
