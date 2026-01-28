import { PrismaClient } from '@prisma/client';
import { User, UserStatus } from '../../domain/user/entity';
import { IUserRepository } from '../../domain/user/repository';

/**
 * Prisma User Repository Implementation
 */
export class PrismaUserRepository implements IUserRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async findById(id: string): Promise<User | null> {
    const record = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!record) return null;

    return User.fromPersistence({
      id: record.id,
      email: record.email,
      name: record.name,
      status: record.status as UserStatus,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    const record = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!record) return null;

    return User.fromPersistence({
      id: record.id,
      email: record.email,
      name: record.name,
      status: record.status as UserStatus,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    });
  }

  async findAll(options?: {
    limit?: number;
    offset?: number;
    status?: string;
  }): Promise<User[]> {
    const records = await this.prisma.user.findMany({
      where: options?.status ? { status: options.status } : undefined,
      take: options?.limit ?? 20,
      skip: options?.offset ?? 0,
      orderBy: { createdAt: 'desc' },
    });

    return records.map((record) =>
      User.fromPersistence({
        id: record.id,
        email: record.email,
        name: record.name,
        status: record.status as UserStatus,
        createdAt: record.createdAt,
        updatedAt: record.updatedAt,
      })
    );
  }

  async save(user: User): Promise<User> {
    const data = user.toJSON();

    const record = await this.prisma.user.upsert({
      where: { id: data.id },
      create: {
        id: data.id,
        email: data.email,
        name: data.name,
        status: data.status,
      },
      update: {
        email: data.email,
        name: data.name,
        status: data.status,
      },
    });

    return User.fromPersistence({
      id: record.id,
      email: record.email,
      name: record.name,
      status: record.status as UserStatus,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.user.delete({
      where: { id },
    });
  }

  async count(options?: { status?: string }): Promise<number> {
    return this.prisma.user.count({
      where: options?.status ? { status: options.status } : undefined,
    });
  }
}
